terraform {
  required_providers {
    openstack = {
        source = "terraform-provider-openstack/openstack"
        version = "1.53.0"
    }
  }
}
provider "openstack" {
  user_name   = "admin"
  tenant_name = "admin"
  password    = "FormationTerraform1234."
  auth_url    = "https://5.135.138.197:5000/v3/"
  region      = "microstack"
  insecure = true
}

resource "openstack_networking_network_v2" "example_network" {
  name = "example-network"
}
resource "openstack_networking_subnet_v2" "example_subnet" {
  name = "example-subnet"
  network_id = openstack_networking_network_v2.example_network.id
  cidr = "192.168.0.0/24"
}