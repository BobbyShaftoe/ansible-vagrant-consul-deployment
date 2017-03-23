# Packer build configuration for creating a Docker registry service as an AMI
### This implements the 'amazon-ebs' builder and 'ansible-local' provisioner
    Note the roles in the main ansible project tree that have been included as dependencies of the Ansible provisioner configuration.


### How to build
Run packer from the command line, referencing examples below for more detail;
the two key requirements however, are the vars:
* HTPASSWD
* ssh_username

The actual command currently being used to build the machine image is:

```packer build -var 'HTPASSWD=**************'  -var 'ssh_username=centos' docker-registry-server.json```



##### Pass in values if Environment variables not setup or to override.

* ```aws_access_key```
* ```aws_secret_key```
* ```aws_default_region```
* ```source_ami```
* ```instance_type```
* ```ssh_username```
* ```ami_name```
* etc

##### Example:

    $ packer build \
        -var 'aws_access_key=xxx' \
        -var 'aws_secret_key=xxx' \
        -var 'aws_default_region=xxx' \
        -var 'source_ami=xxx' \
        -var 'instance_type=t2.micro' \
        -var 'ssh_username=centos' \
        -var 'ami_name=centos7-docker-registry-server' \
        docker-registry-server.json



#### Source_ami takes format of:
```ami-xxxxxxxx```

#### Instance_type is of format:
* ```t2.micro```
* ```m3.medium```
* ```c4.large```

##### -var 'ssh_username'
* Ubuntu: ```ubuntu```
* CentOS: ```centos```
* Amazon Linux: ```ec2-user```

##### -var 'ami_name'
 - Specify custom AMI name at build time
    * "docker-registry" =  AMI named "docker-registry"




