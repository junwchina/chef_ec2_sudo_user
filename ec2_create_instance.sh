#!/bin/bash 

# TODO 
# 1. create ec2 instance 
# 2. return publick DNS


# define exit status 
CREATE_INSTANCE_FAILED=1 

# get from ec2
INSTANCE_ID=''
PUBLIC_DNS=''

# load config
source ./config.sh

function create_instance {
  res=$(ec2-run-instances --instance-type $INSTANCE_TYPE --group $GROUP --region $REGION -k $KEYPAIR $AMI)
  if [ $? != 0 ]; then 
    echo "$res";
    exit $CREATE_INSTANCE_FAILED;
  else 
    INSTANCE_ID=$(echo "$res"| grep INSTANCE | awk '{print $2}')
  fi
}

function get_pub_DNS {
  pub_DNS=$(ec2-describe-instances $INSTANCE_ID | grep INSTANCE|awk '{print $4}')
  if [ $(echo "$pub_DNS" | grep "amazonaws.com") != "" ]; then 
    PUBLIC_DNS=$pub_DNS
  else 
    echo ""
  fi
}

function if_created_instance {
  get_pub_DNS
  while [ $PUBLIC_DNS == '' ]; do 
    echo "EC2 instance is creating, please wait a moment."
    sleep 2
    get_pub_DNS
  done
  echo Your instance publick DNS is "$PUBLIC_DNS", please remember it, and you will use it later.
}


read -p "Do you want to create new ec2 instance? [Yy/Nn]" answer
case "$answer" in 
  [yY])  
    create_instance 
    if_created_instance
    echo $INSTANCE_ID > $INSTANCE_ID_FILE
    echo $PUBLIC_DNS > $INSTANCE_PUB_DNS_FILE
    ;;
  *);;
esac 
