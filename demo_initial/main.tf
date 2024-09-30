variable "var_1" {
  description = "first variable"
  type = string
  default = "value"
}

output "output_var_1" {
  value = var.var_1
}

output "outpit_first_object_props1" {
  value = var.first_object.props1
}