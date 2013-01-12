#!/bin/bash 
#
# ./ec2_cook.sh [host]
#

# load config 
source config.sh

# load tool
source tool.sh


pub_dns=$(get_pub_dns $1)

if [ "$pub_dns" == "" ]; then 
  echo "Please pass a ec2 hostname as the first argument"
  exit  $NO_HOST_EXIT
else
  knife cook focus@$pub_dns
fi


