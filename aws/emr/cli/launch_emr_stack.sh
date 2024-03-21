#!/usr/bin/env bash

aws emr create-cluster \
  --applications Name=Ganglia Name=Spark Name=Zeppelin Name=Hive \
  --ebs-root-volume-size 10 \
  --ec2-attributes '{"KeyName":"nb-keypair-02","InstanceProfile":"EMR_EC2_DefaultRole","SubnetId":"subnet-f1404cb8","EmrManagedSlaveSecurityGroup":"sg-bc6a32cb","EmrManagedMasterSecurityGroup":"sg-34673f43"}' \
  --service-role EMR_DefaultRole \
  --enable-debugging \
  --release-label emr-5.11.1 \
  --log-uri 's3n://aws-logs-088841113972-us-east-1/elasticmapreduce/' \
  --name 'R Cluster 00' \
  --instance-groups '[{"InstanceCount":1,"EbsConfiguration":{"EbsBlockDeviceConfigs":[{"VolumeSpecification":{"SizeInGB":32,"VolumeType":"gp2"},"VolumesPerInstance":1}]},"InstanceGroupType":"MASTER","InstanceType":"r4.xlarge","Name":"Master Instance Group"},{"InstanceCount":2,"EbsConfiguration":{"EbsBlockDeviceConfigs":[{"VolumeSpecification":{"SizeInGB":32,"VolumeType":"gp2"},"VolumesPerInstance":1}]},"InstanceGroupType":"CORE","InstanceType":"r4.xlarge","Name":"Core Instance Group"}]' \
  --configurations '[{"Classification":"spark","Properties":{"maximizeResourceAllocation":"true"},"Configurations":[]}]' \
  --scale-down-behavior TERMINATE_AT_TASK_COMPLETION \
  --region us-east-1

