#!/bin/bash 


# define EC2 variables
AMI='ami-7539b41c'          # will use it to run a new ec2 instance
INSTANCE_TYPE='t1.micro'    # if you just want to have a test, you may should set to t1.micro
GROUP='default'             # group, see detail in aws.
REGION='us-east-1'          # you can set the closest localtion for your server.
KEYPAIR='amazon-keypair'    # our default keypair


KEYPAIR=~/.ec2/amazon-keypair
INSTANCE_PUB_DNS_FILE=/tmp/.ec2_public_dns          # save pub dns to a tmp file
INSTANCE_ID_FILE=/tmp/.ec2_instance_id              # save instance_id to a tmp file
