resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "local_file" "private_key" {
  filename = "${path.module}/ihab-exercice-key.pem"
  content = tls_private_key.key.private_key_pem
  file_permission = "0400"
}

resource "openstack_compute_keypair_v2" "keypair" {
  name       = var.keypair_name
  public_key = tls_private_key.key.public_key_openssh
}

