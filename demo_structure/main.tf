variable "demo_condition" {
  description = "value of the condition"
  type = bool
  default = false
}

output "output_condition" {
  value = var.demo_condition ? "the condition is true" : "the condition is false"
}

variable "list_of_strings" {  
    description = "A list of strings"  
    type        = list(string)  
    default     = ["apple", "banana", "cherry"]
}
output "lengths_of_strings" { 
     value = [for s in var.list_of_strings : length(s)]
}