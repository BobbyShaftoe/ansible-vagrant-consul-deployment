


module "security_group_consul_clients" {
  source = "ec2_consul_clients"
  consul_vpc_id = "${var.consul_vpc_id}"
 // consul_sec_gr_elb = "${module.security_group_elb.consul_sec_gr_elb}"
  cidr = "${var.cidr}"
  tags = "${var.tags}"
}

module "security_group_elb" {
  source = "elb"
  consul_vpc_id = "${var.consul_vpc_id}"
  consul_sec_gr_front = "${module.security_group_elb.consul_sec_gr_front}"
  cidr = "${var.cidr}"
  tags = "${var.tags}"
}

