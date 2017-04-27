# Create a VPC to launch our instances into
resource "aws_vpc" "consul_vpc_id" {
  cidr_block = "${var.cidr}"
  enable_dns_hostnames = true
  enable_dns_support = true
  instance_tenancy = "default"
  lifecycle {
    create_before_destroy = true
  }
  tags {
    Name = "${var.tags[2]}"
  }
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "consul_int_gw_id" {
  vpc_id = "${aws_vpc.consul_vpc_id.id}"
  tags {
    Name = "${var.tags[2]}"
  }
}

resource "aws_vpc_dhcp_options" "consul_vpc_dhcp_id" {
  domain_name = "us-east-1.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]
    tags {
    Name = "${var.tags[2]}"
  }
}