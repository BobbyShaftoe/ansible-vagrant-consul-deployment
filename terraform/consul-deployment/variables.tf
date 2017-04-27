
variable "aws_region" {
  description = "AWS region to operate"
  default = "us-east-1"
}

variable "tags" {
  type = "list"
  default = ["consul_client", "consul_server", "consul_deployment"]
}

variable "cidr" {
  description = "CIDR for the whole VPC"
  default = "172.20.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR_AZ"
  type = "list"
  default = ["172.20.10.0/24", "172.20.20.0/24", "172.20.30.0/24", "172.20.40.0/24", "172.20.50.0/24", "172.20.60.0/24"]
}

variable "az" {
  description = "Avalability Zones"
  type = "list"
  default = ["us-east-1a", "us-east-1b", "us-east-1c",]
}

variable "my_ip" {
  description = "My app to allow to connect to security group"
}


variable "consul_buckets" {
  description = "bucket for access logs"
  type = "list"
  default = ["consul-client-bucket", "consul-server-bucket", "consul-elb-bucket"]
}

variable "consul_bucket_prefix" {
  description = "bucket prefix for access logs"
  default = "logs"
}

variable "aws_id" {
  description = "AWS ROOT ID"
  default = "088841113972"
}

variable "consul_key_consul_client" {
  description = "key to use for consul clients"
  default = "nb-keypair-02"
}

variable "consul_key_consul_server" {
  description = "key to use for consul servers"
  default = "nb-keypair-02"
}
