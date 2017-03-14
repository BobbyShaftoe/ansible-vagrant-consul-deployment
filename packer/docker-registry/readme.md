### How to build

#### Environment variables
##### Pass values if ENV not setup or to override.

* ```aws_access_key```
* ```aws_secret_key```
* ```aws_default_region```
* ```source_ami```
* ```instance_type```
* ```ssh_username```
* ```ami_name```
* etc

| example |   ```-var  'aws_access_key=xxx'```

    $ packer build \
        -var 'aws_access_key=xxx' \
        -var 'aws_secret_key=xxx' \
        -var 'aws_default_region=xxx' \
        -var 'source_ami=xxx' \
        -var 'instance_type=xxx' \
        -var 'ssh_username=xxx' \
        -var 'ami_name=xxx' \
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
 - Append "-packer" to the end of the AMI name
    * "new-server" =  AMI named "new-server-packer"


Example:

    $ packer build \
        -var 'source_ami=ami-xxxxxx' \
        -var 'instance_type=t2.micro' \
        -var 'ssh_username=centos' \
        -var 'ami_name=centos7-docker-registry-server' \
        docker-registry-server.json
