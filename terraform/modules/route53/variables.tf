// Module specific variables
variable "hosted_zone_id" {
  description = "ID for the domain hosted zone"
}

variable "domain_name" {
  description = "name of the domain where record(s) need to create"
}

variable "elb_address" {
  description = "ELB address for which record need to create"
}

variable "elb_zone_id" {
  description = "Zone id for ELB"
}




//  region: us-east-1
//  owner: 088841113972
//
//  ami_id: ami-1a0aba0c
//  instance_type: t2.micro
//  key_pair: nb-keypair-01
//
//  security_group_id: sg-cf2a2bb3
//  security_group: secure-sg-1
//  vpc_id: vpc-22b2cf44
//  subnet_id: subnet-94d1f3b9
//
//
//  zone_name: aws-halcyon-infra.net
//  zone_id: ZXDO38WX4GN6I