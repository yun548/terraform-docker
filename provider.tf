provider "openstack" {
    auth_url = "https://auth.cloud.ovh.net/v3.0/"
    domain_name = "default"
    alias = "ovh"

    user_name   = "Your openstack username"
    password    = "Your openstack password"
}
