variable "name_vm" {
  type = string
  description = "vm name"
}

variable "image_id" {
  type = number
  description = "image id"
}

variable "flavor_id" {
  type = number
  description = "flavor id"
}
variable "keypair_name" {
  type = string
  description = "keypair name"
}

variable "security_groups" {
  type = list(string)
  description = "security group"
}

variable "network_id" {
  type = number
  description = "network id"
}