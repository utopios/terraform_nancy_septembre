variable "environment" {
  type = string
  description = "The environment of the infrastrcture should be prod or dev"

  ## Bloque de validation des variables
  validation {
    condition = contains(["dev", "prod"], var.environment)
    # Une autre façon de faire le controle
    #condition = length(regexall("^(prod|dev)$", var.environment)) > 0
    error_message = "The environment must be prod and dev ${var.environment}"
  }
}

variable "instance_type" {
  type = string
  description = "The type of instance "

  ## Bloque de validation des variables
  validation {
    condition = contains(["small", "large"], var.instance_type)
    # Une autre façon de faire le controle
    #condition = length(regexall("^(prod|dev)$", var.environment)) > 0
    error_message = "The type must be small or large"
  }
}

variable "names" {
  description = "list of names"
  type = set(string)
  default = [ "toto", "tata" ]
}


# variable "message" {
#   type = set(string)
#   default = [ for s in var.names : "welecome ${s}" ]
# }

# variable "instance_size" {
#     type = string
#     default = var.instance_type == "small" ? "t2.micro": "t2.large"
# }

# locals {
#     instance_size = var.instance_type == "small" ? "t2.micro": "t2.large"
#     message  = [ for s in var.names : "welecome ${s}" ]
# }

output "out_put_instance_size" {
  value = local.instance_size
}

output "welecome_message" {
  value = local.message
}