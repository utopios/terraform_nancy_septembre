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

resource "openstack_images_image_v2" "ubuntu_image" {
  name            = "ubuntu-20.04"
  image_source_url = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
  disk_format     = "qcow2"
  container_format = "bare"
  lifecycle {
    prevent_destroy = true
  }
}

# Data source to retrieve the image by name
data "openstack_images_image_v2" "my_image" {
  name = "ubuntu-20.04"
}

# Output the image ID
output "image_id" {
  value = data.openstack_images_image_v2.my_image.id
}

data "openstack_compute_flavor_v2" "small" {
  name = "m1.small"
}

resource "openstack_compute_instance_v2" "iha_vm" {
  name = "example-instance"
  image_id = data.openstack_images_image_v2.my_image.id
  flavor_id = data.openstack_compute_flavor_v2.small.id
  key_pair = openstack_compute_keypair_v2.ihab-keypair.name
  security_groups = ["default"]
  network {
    uuid = openstack_networking_network_v2.example_network.id
  }
}
# Générer une clé privée localement
resource "tls_private_key" "ihab_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

# Enregistrer la clé privée localement dans un fichier
resource "local_file" "private_key" {
    filename = "${path.module}/ihab-key.pem"
    content = tls_private_key.ihab_key.private_key_pem

    file_permission = "0400"
}


resource "openstack_compute_keypair_v2" "ihab-keypair" {
  name       = "ihab-keypair"
  public_key = tls_private_key.ihab_key.public_key_openssh
}

resource "openstack_blockstorage_volume_v3" "ihab-vol" {
  name = "myvol"
  size = 20
}

resource "openstack_compute_volume_attach_v2" "attached" {
  instance_id = openstack_compute_instance_v2.iha_vm.id
  volume_id   = openstack_blockstorage_volume_v3.ihab-vol.id
}