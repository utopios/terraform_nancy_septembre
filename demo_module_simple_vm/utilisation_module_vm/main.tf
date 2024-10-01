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

module "simple_vm" {
  source = "../module_vm"
  name_vm = "vm1"
  image_id = 1
  flavor_id = 1
  security_groups = ["default"]
  keypair_name = ""
  network_id = 1
}