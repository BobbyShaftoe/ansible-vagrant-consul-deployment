resource "aws_route53_record" "main" {
  zone_id = "${var.hosted_zone_id}"
  name = "${var.domain_name}"
  type = "A"
  ttl  = "300"
  records = ["${var.public_ip}"]

}

output instance_fqdn {
  value = "${aws_route53_record.main.fqdn}"
}




