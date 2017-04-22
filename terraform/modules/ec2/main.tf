
resource "aws_eip" "default" {
  instance = "${aws_instance.ec2.id}"
  vpc      = true
}

resource "aws_instance" "ec2" {

  ami = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  vpc_security_group_ids = ["${var.security_group_id}"]
  key_name = "${var.key_name}"
  instance_type = "${var.instance_type}"
  count = "${var.count}"
  subnet_id = "${var.subnet_id}"
  root_block_device {
    volume_type = "${var.ebs_root_volume_type}"
    volume_size = "${var.ebs_root_volume_size}"
    delete_on_termination = "${var.ebs_root_delete_on_termination}"
  }
  tags {
    Name          = "${var.name} ${var.environment} ${format("%02d", count.index+1)}"
    environment   = "${var.environment}"
    server_role   = "${var.server_role}"
    domain_name   = "${var.domain_name}"
  }
  user_data = "${var.user_data}"
}

output "ec2_id" {
  value = "${join(",", aws_instance.ec2.*.id)}"
}

output "ec2_public_ip" {
  value = "${aws_eip.default.public_ip}"
}

