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

# resource "openstack_images_image_v2" "ubuntu_image" {
#   name            = "ubuntu-20.04"
#   image_source_url = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
#   disk_format     = "qcow2"
#   container_format = "bare"
# }

# Data source to retrieve the image by name
data "openstack_images_image_v2" "my_image" {
  name = "ubuntu-20.04"
}

# Output the image ID
output "image_id" {
  value = data.openstack_images_image_v2.my_image.id
}