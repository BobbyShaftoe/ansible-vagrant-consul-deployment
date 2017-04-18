
output docker_registry_instance_fqdn {
  value ="${module.route53simple.instance_fqdn}"
}

output docker_registry_public_ip {
  value = "${module.ec2.ec2_public_ip}"
}

