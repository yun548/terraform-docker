resource "openstack_compute_keypair_v2" "prod_keypair" {
    provider = openstack.ovh
    name = "prod_keypair"

    public_key = file("~/.ssh/id_rsa.pub")
}

# Création d'une machine virtuelle OpenStack
resource "openstack_compute_instance_v2" "rabbitmq" {
    name = "rabbitmq"
    provider = openstack.ovh
    image_name = "Debian 10 - Docker"
    flavor_name = "s1-2"
    key_pair = openstack_compute_keypair_v2.prod_keypair.name
    region = var.region

    network {
        name = "Ext-Net"
    }

    connection {
        type = "ssh"
        user = "debian"
        private_key = file("~/.ssh/id_rsa")
        host = self.access_ip_v4
    }

    provisioner "remote-exec" {
        inline = [
            # We are creating a rabbitmq instance here but feel free to change it
            "docker pull rabbitmq:3.8-management-alpine",
            "docker run -d -p 15672:15672 -p 5672:5672 --hostname my-rabbit --name some-rabbit rabbitmq:3.8-management-alpine",
        ]
    }
}
