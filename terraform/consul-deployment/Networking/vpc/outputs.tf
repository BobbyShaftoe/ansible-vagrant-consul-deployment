output "consul_vpc_id" {
  value = "${aws_vpc.consul_vpc_id.id}"
}

output "consul_int_gw_id" {
  value = "${aws_internet_gateway.consul_int_gw_id.id}"
}

output "consul_route_table_id" {
  value = "${aws_vpc.consul_vpc_id.main_route_table_id}"
}

output "consul_vpc_dhcp_id" {
  value = "${aws_vpc.consul_vpc_id.dhcp_options_id}"
}

