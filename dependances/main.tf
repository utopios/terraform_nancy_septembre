# resource "null_resource" "resource1" {
#   attribut1_resource_1 = "val1"
# }

# resource "null_resource" "resource2" {
#     attribut1_resource_2 = null_resource.resource1.attribut1_resource_1
# }

# resource "null_resource" "resource3" {
#   attribut1_resource_3 = "val1"
# }

# resource "null_resource" "resource4" {
#   attribut1_resource_4 = "val1"

#   depends_on = [ null_resource.resource3, null_resource.resource2 ]
# }

resource "null_resource" "resource0" {
  attribut1_resource_0 = "val1"
}

# variable "trigger_var" {
#   description = "trigger update resource 1"
# }

variable "ex" {
  type = string
  default = "value"
}

resource "null_resource" "resource1" {
  lifecycle {
    prevent_destroy = false
    create_before_destroy = false
    ignore_changes = [ attribute1 ]
    replace_triggered_by = [ null_resource.resource0.attribut1_resource_0 ]
    
  }
}

resource "null_resource" "resource2" {
  depends_on = [ null_resource.resource1 ]
}

resource "null_resource" "example1" {
  example_attribut = var.ex
}