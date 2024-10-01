

data "openstack_images_image_v2" "image" {
  name = var.image_name
}

data "openstack_compute_flavor_v2" "flavor" {
  name = var.flavor_name
}

resource "openstack_compute_instance_v2" "instance" {
  name           = var.instance_name
  image_id       = data.openstack_images_image_v2.image.id
  flavor_id      = data.openstack_compute_flavor_v2.flavor.id
  key_pair       = var.keypair_name
  security_groups = ["default"]

  network {
    uuid = var.network_id
  }
}

