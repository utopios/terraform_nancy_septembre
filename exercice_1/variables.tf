 variable "first_name" {
  description = "the first name of the student"
  type = string
}
variable "last_name" {
  description = "the last name of the student"
  type = string
}

variable "age" {
  description = "the age of the student"
  type = number
}

variable "is_student" {
  description = "Whether the person is a student"
  type = bool
  default = false
}

variable "courses" {
  description = "the list of courses the student is taking"
  type = list(string)
  default = [ "Math", "Science" ]
}

variable "grades" {
  description = "the grades of the student in each course"
  type = map(number)
  default = {
    "Math" = 90,
    "Science" = 90
  }
}

variable "student" {
  description = "The details of the student"
  type = object({
    first_name = string
    last_name = string
    age = number
    is_student = bool
    courses = list(string)
    grades = map(number) 
  })
}