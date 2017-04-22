
variable aws_region {
  default = "us-east-1"
}

variable domain_name {
  default = "docker-registry2.aws-halcyon-infra.net"
}

variable hosted_zone_id {
  default = "ZXDO38WX4GN6I"
}

variable instance_name {
  default = "Docker Registry"
}

variable environment {
  default = "Test"
}

variable role {
  default = "Docker Registry"
}

variable ami_id {
  default = "ami-f6e27ee0"
}

variable key_name {
  default = "nb-keypair-02"
}

variable security_group_id {
  default = "sg-cf2a2bb3"
}

variable subnet_id {
  default = "subnet-94d1f3b9"
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
//  zone_name: aws-halcyon-infra.net
//  zone_id: ZXDO38WX4GN6I
