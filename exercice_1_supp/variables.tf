variable "vm_config" {
  description = "Liste des vm à créer"
  type = list(object({
    name = string
    flavor = string
    volume_size = number
    image_name = string
  }))

  default = [ {
    
  } ]
}