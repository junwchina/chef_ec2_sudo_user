#!/bin/bash 
#
# ./ec2_prepare.sh [host]
#

# load config 
source config.sh

# load tool
source tool.sh


pub_dns=$(get_pub_dns)

knife prepare -i $KEYPAIR ubuntu@$pub_dns


