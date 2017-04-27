output "consul_int_route_1_id" {
  value = "${aws_route_table.consul_int_route_1.id}"
}

output "consul_ext_route_0_id" {
  value = "${aws_route.consul_ext_route_0.id}"
}
