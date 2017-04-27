# Create securety groups and open port
resource "aws_security_group" "consul_sec_retail_elb" {
  name = "retail_elb"
  description = "front server securety group"
  vpc_id = "${var.consul_vpc_id}"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [
      "${var.consul_sec_gr_front}"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "${var.cidr}"]
  }
  tags {
    Name = "${var.tags[0]}"
  }
}
