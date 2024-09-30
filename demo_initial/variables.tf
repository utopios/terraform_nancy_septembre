variable "first_object" {
  description = "first object"
  type = object({
    props1 = string
    props2 = string
    props3 = object({
      sub_props1 = string 
    }) 
  })
  default = {
    props1 = "value"
    props2 = "value2"
    props3 = {
      sub_props1 = "value"
    }
  }
}