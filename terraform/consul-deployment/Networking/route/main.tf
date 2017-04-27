resource "aws_route_table" "consul_ext_route_0" {
  vpc_id = "${var.consul_vpc_id}"
  tags {
    Name = "${var.tags[0]}"

  }
}

resource "aws_route" "consul_ext_route_0" {
  route_table_id = "${var.consul_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${var.consul_int_gw_id}"
}

resource "aws_main_route_table_association" "consul_ext_route_0" {
  vpc_id = "${var.consul_vpc_id}"
  route_table_id = "${var.consul_route_table_id}"
}

# Associate Subnets to routing table
resource "aws_route_table_association" "api_ext_ass0" {
  subnet_id = "${var.consul_ext_subnet_ids[0]}"
  route_table_id = "${aws_route_table.consul_ext_route_0.id}"
}

resource "aws_route_table_association" "api_ext_ass1" {
  subnet_id = "${var.consul_ext_subnet_ids[1]}"
  route_table_id = "${aws_route_table.consul_ext_route_0.id}"
}

resource "aws_route_table_association" "api_ext_ass2" {
  subnet_id = "${var.consul_ext_subnet_ids[2]}"
  route_table_id = "${aws_route_table.consul_ext_route_0.id}"
}

# Create new routing table without internet access for minin instances
resource "aws_route_table" "consul_int_route_1" {
  vpc_id = "${var.consul_vpc_id}"
  tags {
    Name = "${var.tags[1]}"

  }
}

# Associate Subnets to routing table
resource "aws_route_table_association" "api_int_ass3" {
  subnet_id = "${var.consul_int_subnet_ids[0]}"
  route_table_id = "${aws_route_table.consul_int_route_1.id}"
}

resource "aws_route_table_association" "api_int_ass4" {
  subnet_id = "${var.consul_int_subnet_ids[1]}"
  route_table_id = "${aws_route_table.consul_int_route_1.id}"
}

resource "aws_route_table_association" "api_int_ass5" {
subnet_id = "${var.consul_int_subnet_ids[2]}"
route_table_id = "${aws_route_table.consul_int_route_1.id}"
}
