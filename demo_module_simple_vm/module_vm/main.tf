resource "openstack_compute_instance_v2" "vm_openstack_module" {
  name = var.name_vm
  image_id = var.image_id
  flavor_id = var.flavor_id
  key_pair = var.keypair_name
  security_groups = var.security_groups
  network {
    uuid = var.network_id
  }
}