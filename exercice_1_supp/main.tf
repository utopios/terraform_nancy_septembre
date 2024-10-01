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



resource "openstack_networking_network_v2" "exercice1_ihab_network" {
  name = "exercice1_ihab_network"
}
resource "openstack_networking_subnet_v2" "exercice1_ihab_subnet" {
  name = "exercice1_ihab_subnet"
  network_id = openstack_networking_network_v2.exercice1_ihab_network.id
  cidr = "192.168.0.0/24"
}

# Générer une clé privée localement
resource "tls_private_key" "ihab_exercice_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

# Enregistrer la clé privée localement dans un fichier
resource "local_file" "private_key" {
    filename = "${path.module}/ihab-exercice-key.pem"
    content = tls_private_key.ihab_exercice_key.private_key_pem

    file_permission = "0400"
}


resource "openstack_compute_keypair_v2" "ihab_exercice_keypair" {
  name       = "ihab-exercice-keypair"
  public_key = tls_private_key.ihab_exercice_key.public_key_openssh
}

resource "openstack_blockstorage_volume_v3" "ihab_exerice_vol" {
  for_each = var.vm_config 
  name = "${each.value.name}-volume"
  size = each.value.volume_size
}


# Data source to retrieve the image by name
data "openstack_images_image_v2" "ihab_exerice_image" {
  for_each = var.vm_config 
  name = each.value.image_name
}

# # Output the image ID
# output "image_id" {
#   for_each = var.vm_config 
#   value = data.openstack_images_image_v2.ihab_exerice_image[each.key].id
# }

data "openstack_compute_flavor_v2" "exercice_ihab_flavor" {
  for_each = var.vm_config 
  name = each.value.flavor
}

resource "openstack_compute_instance_v2" "ihab_exercice_vm" {
  for_each = var.vm_config 
  name = "${each.value.name}-instance"
  image_id = data.openstack_images_image_v2.ihab_exerice_image[each.key].id
  flavor_id = data.openstack_compute_flavor_v2.exercice_ihab_flavor[each.key].id
  key_pair = openstack_compute_keypair_v2.ihab_exercice_keypair.name
  security_groups = ["default"]
  network {
    uuid = openstack_networking_network_v2.exercice1_ihab_network.id
  }
}




resource "openstack_compute_volume_attach_v2" "attached" {
  for_each = var.vm_config   
  instance_id = openstack_compute_instance_v2.ihab_exercice_vm[each.key].id
  volume_id   = openstack_blockstorage_volume_v3.ihab_exerice_vol[each.key].id
}