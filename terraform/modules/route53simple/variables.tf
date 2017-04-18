// Module specific variables
variable "hosted_zone_id" {
  description = "ID for the domain hosted zone"
}

variable "domain_name" {
  description = "name of the domain where record(s) need to create"
}

variable "public_ip" {
  description = "Public IP address of instance or resource"
}

