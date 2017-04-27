// Module specific variables
variable "name" {
  description = "Instance name"
  default = "default"
}

variable "domain_name" {
  description = "Domain A record name"
}

variable "environment" {
  description = "Name of environment type this instance is in"
  default = "default environment"
}

variable "server_role" {
  description = "Name of role type for this instance"
  default = "default server role"
}

variable "instance_type" {
	description = "Type of instance"
	default = "t2.micro"
}

variable "key_name" {
	description = "SSH keypair you've created"
}

variable "user_data" {
	description = "User data that need to pass to the instance(s)"
}

variable "security_group_id" {
	description = "Security Group you've created"
}

variable "subnet_id" {
  description = "The VPC subnet the instance(s) will go in"
}

variable "ami_id" {
  description = "AMI used to spin-up this EC2 Instance"
}

variable "count" {
  description = "Number of instance(s) to be launched"
  default = "1"
}

variable "ebs_root_volume_type" {
  default = "gp2"
}

variable "ebs_root_volume_size" {
  default = "8"
}

variable "ebs_root_delete_on_termination" {
  default = "true"
}
