# Create external facing subnets in us-east-1a AZ
data "aws_vpc" "selected" {
  id = "${var.consul_vpc_id}"

  filter {
    name = "default"
    values = ["false"]
  }
}

# Create external facing subnets in us-east-1a AZ
resource "aws_subnet" "consul_ext_subnet_0" {
  count = 1
  vpc_id = "${data.aws_vpc.selected.id}"
  cidr_block = "${var.subnet_cidr[0]}"
  availability_zone = "${var.az[0]}"
  map_public_ip_on_launch = true
  tags {
    Name = "${var.tags[0]}"
  }
}

# Create external facing subnets in us-east-1b AZ
resource "aws_subnet" "consul_ext_subnet_1" {
  vpc_id = "${data.aws_vpc.selected.id}"
  cidr_block = "${var.subnet_cidr[1]}"
  availability_zone = "${var.az[1]}"
  map_public_ip_on_launch = true
  tags {
    Name = "${var.tags[0]}"
  }
}

# Create external facing subnets in us-east-1c AZ
resource "aws_subnet" "consul_ext_subnet_2" {
  vpc_id = "${data.aws_vpc.selected.id}"
  cidr_block = "${var.subnet_cidr[2]}"
  availability_zone = "${var.az[2]}"
  map_public_ip_on_launch = true
  tags {
    Name = "${var.tags[0]}"
  }
}

# Create internal facing subnets in us-east-1a AZ
resource "aws_subnet" "consul_int_subnet_3" {
  vpc_id = "${data.aws_vpc.selected.id}"
  cidr_block = "${var.subnet_cidr[3]}"
  availability_zone = "${var.az[0]}"
  map_public_ip_on_launch = false
  tags {
    Name = "${var.tags[1]}"
  }
}

# Create internal facing subnets in us-east-1b AZ
resource "aws_subnet" "consul_int_subnet_4" {
  vpc_id = "${data.aws_vpc.selected.id}"
  cidr_block = "${var.subnet_cidr[4]}"
  availability_zone = "${var.az[1]}"
  map_public_ip_on_launch = false
  tags {
    Name = "${var.tags[1]}"
  }
}

# Create internal facing subnets in eus-east-1c AZ
resource "aws_subnet" "consul_int_subnet_5" {
  vpc_id = "${data.aws_vpc.selected.id}"
  cidr_block = "${var.subnet_cidr[5]}"
  availability_zone = "${var.az[2]}"
  map_public_ip_on_launch = false
  tags {
    Name = "${var.tags[1]}"
  }
}
