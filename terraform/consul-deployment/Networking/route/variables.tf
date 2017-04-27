variable "consul_vpc_id" {
}

variable "tags" {
  type = "list"
}

variable "consul_route_table_id" {
}

variable "consul_int_gw_id" {
}

variable "consul_ext_subnet_ids" {
  type = "list"
}

variable "consul_int_subnet_ids" {
  type = "list"
}