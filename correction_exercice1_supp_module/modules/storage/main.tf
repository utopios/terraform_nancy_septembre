resource "openstack_blockstorage_volume_v3" "volume" {
  name = var.volume_name
  size = var.volume_size
}