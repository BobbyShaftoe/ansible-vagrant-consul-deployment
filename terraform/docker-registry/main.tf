
provider "aws" {
    region = "${var.aws_region}"
	shared_credentials_file = "/Users/nicksinclair/.aws/credentials"
	profile = "default"
}

module "ec2" {
	source = "../modules/ec2"
	name = "${var.instance_name}"
	environment = "${var.environment}"
	server_role = "${var.role}"
	ami_id = "${var.ami_id}"
	key_name = "${var.key_name}"
	count = "1"
	security_group_id = "${var.security_group_id}"
	subnet_id = "${var.subnet_id}"
	instance_type = "t2.micro"
	domain_name = "{var.domain_name}"
	user_data = "#!/bin/bash\necho done"
}


module "route53simple" {
    source = "../modules/route53simple"
    hosted_zone_id = "${var.hosted_zone_id}"
    domain_name = "${var.domain_name}"
    public_ip = "${module.ec2.ec2_public_ip}"

}

