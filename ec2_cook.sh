#!/bin/bash 
#
# ./ec2_cook.sh [host]
#

# load config 
source config.sh

# load tool
source tool.sh


pub_dns=$(get_pub_dns)

knife cook -i $KEYPAIR ubuntu@$pub_dns
