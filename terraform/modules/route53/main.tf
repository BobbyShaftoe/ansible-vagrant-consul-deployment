resource "aws_route53_record" "main" {
  zone_id = "${var.hosted_zone_id}"
  name = "${var.domain_name}"
  type = "A"

  alias {
    name = "${var.elb_address}"
    zone_id = "${var.elb_zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www" {
  zone_id = "${var.hosted_zone_id}"
  name = "www.${var.domain_name}"
  type = "CNAME"
  ttl = "300"
  records = ["${var.domain_name}"]
}


//  resource "aws_route53_record" "www" {
//    zone_id = "${aws_route53_zone.primary.zone_id}"
//    name    = "www.example.com"
//    type    = "A"
//    ttl     = "300"
//    records = ["${aws_eip.lb.public_ip}"]
//  }