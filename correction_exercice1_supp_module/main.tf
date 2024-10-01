

locals {
  vm_config_local = jsondecode(file("${path.module}/data.json"))
  vm_config_local_map = {for index, vm in local.vm_config_local: vm.name => vm}
}

# Network module
module "network" {
  source      = "../modules/network"
  network_name = "exercice1_ihab_network"
  subnet_name = "exercice1_ihab_subnet"
  cidr        = "192.168.0.0/24"
}

# Keypair module
module "keypair" {
  source       = "../modules/keypair"
  keypair_name = "ihab-exercice-keypair"
}

# Storage and compute instances for each VM in vm_config_local_map
module "storage_and_compute" {
  for_each      = local.vm_config_local_map
  source        = "../modules/storage"
  volume_name   = "${each.value.name}-volume"
  volume_size   = each.value.volume_size
}

module "instance" {
  for_each       = local.vm_config_local_map
  source         = "git::https://github.com/utopios/module_vm_openstack.git"
  instance_name  = "${each.value.name}-instance"
  image_name     = each.value.image_name
  flavor_name    = each.value.flavor
  keypair_name   = module.keypair.keypair_name
  network_id     = module.network.network_id
}

# Volume attachment module
module "volume_attach" {
  for_each    = local.vm_config_local_map
  source      = "../modules/volume_attach"
  instance_id = module.instance[each.key].instance_id
  volume_id   = module.storage_and_compute[each.key].volume_id
}