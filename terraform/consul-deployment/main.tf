provider "aws" {
  region = "${var.aws_region}"
  access_key = "AKIAJFECLOZC4ZBNUUPA"
  secret_key = "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"
}

module "vpc" {
  source = "Networking/vpc"
  cidr = "${var.cidr}"
  tags = "${var.tags}"
}

module "subnet" {
  source = "Networking/subnet"
  consul_vpc_id = "${module.vpc.consul_vpc_id}"
  subnet_cidr = "${var.subnet_cidr}"
  az = "${var.az}"
  tags = "${var.tags}"

}

module "route" {
  source = "Networking/route"
  consul_vpc_id = "${module.vpc.consul_vpc_id}"
  consul_route_table_id = "${module.vpc.consul_route_table_id}"
  consul_int_gw_id = "${module.vpc.consul_int_gw_id}"
  consul_ext_subnet_ids = ["${module.subnet.consul_ext_subnet_id_0}", "${module.subnet.consul_ext_subnet_id_1}", "${module.subnet.consul_ext_subnet_id_2}"]
  consul_int_subnet_ids = ["${module.subnet.consul_int_subnet_id_3}", "${module.subnet.consul_int_subnet_id_4}", "${module.subnet.consul_int_subnet_id_5}"]
  tags = "${var.tags}"
}

//module "ec2" {
//	source = "../modules/ec2"
//	name = "${var.instance_name}"
//	environment = "${var.environment}"
//	server_role = "${var.role}"
//	ami_id = "${var.ami_id}"
//	key_name = "${var.key_name}"
//	count = "1"
//	security_group_id = "${var.security_group_id}"
//	subnet_id = "${var.subnet_id}"
//	instance_type = "t2.micro"
//	domain_name = "{var.domain_name}"
//	user_data = "#!/bin/bash\necho done"
//}
//
//module "security_groups" {
//  source = "Networking/security_groups"
//  consul_vpc_id = "${module.vpc.consul_vpc_id}"
//  cidr = "${var.cidr}"
//  my_ip = "${var.my_ip}"
//  tags = "${var.tags}"
//}