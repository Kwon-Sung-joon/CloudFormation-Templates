#!/bin/bash
date=`date \"+%Y%m%d%H%MAMI\"`
aws ec2 create-image --instance-id `aws ec2 describe-instances --query Reservations[].Instances[].InstanceId --filter \"Name=tag:Name, Values=Bastion Host\" --region ap-northeast-2 --output=text` --name $date --no-reboot --region ap-northeast-2 --output=text
ami=`aws ec2 describe-images --filters \"Name=name, Values=$date\" --query Images[].ImageId --region ap-northeast-2  --output=text`
aws ec2 wait image-available --image-ids $ami --region ap-northeast-2
aws ec2 copy-image --source-image-id $ami --source-region ap-northeast-2 --region ap-northeast-3 --name $date[COPY]

          