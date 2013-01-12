#!/bin/bash 

# TODO 
# 1. create ec2 instance 
# 2. return publick DNS
# usage: ./ec2_create_instance.sh

# user json
DEFAULT_NODE_JSON=./nodes/user.json

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
    INSTANCE_ID=$(echo "$res"| grep -e '\bINSTANCE\b' | awk '{print $2}')
  fi
}

function get_pub_DNS {
  pub_DNS=$(ec2-describe-instances $INSTANCE_ID | grep -e '\bINSTANCE\b'|awk '{print $4}')
  if [ $(echo "$pub_DNS" | grep "amazonaws.com") != "" ]; then 
    PUBLIC_DNS=$pub_DNS
  else 
    echo ""
  fi
}


function get_sys_status {
  ec2-describe-instance-status $INSTANCE_ID|grep -e '\bINSTANCE\b' |awk '{print $6}'
}


function get_instance_status {
  ec2-describe-instance-status $INSTANCE_ID|grep -e '\bINSTANCE\b' |awk '{print $NF}'
}

function if_created_instance {
  # check sys status
  sys_stat=$(get_sys_status)
  echo System status: $sys_stat
  while [ "$sys_stat" != "ok" ]; do 
    echo "EC2 instance is initializing."
    sleep 2
    sys_stat=$(get_sys_status)
    echo System status: $sys_stat
  done

  # check instance status
  instance_stat=$(get_instance_status)
  echo Instance status: $instance_stat
  while [ "$instance_stat" != "active" ]; do 
    echo "EC2 instance is initializing."
    sleep 2
    instance_stat=$(get_instance_status)
    echo Instance status: $instance_stat
  done

  # get pub dns
  get_pub_DNS
  while [ $PUBLIC_DNS == '' ]; do 
    echo "EC2 instance is creating, please wait a moment."
    sleep 2
    get_pub_DNS
  done
  echo ==========================================================
  echo You new ec2 instance have been created.
  echo InstanceID: $INSTANCE_ID
  echo Public DNS: $PUBLIC_DNS
  echo Please remember it, because you will use it in the future.
  echo ==========================================================
}


function create_user {
  echo "Start to creating user......"
  # create node.json 
  node_json=./nodes/"$PUBLIC_DNS".json
  cp $DEFAULT_NODE_JSON $node_json

  ## Install User
  knife prepare -i $KEYPAIR_FILE ubuntu@$PUBLIC_DNS
    
  if [ $? -ne 0 ]; then 
    echo "Please check your config and try again."
    exit $?
  fi
  
  knife cook -i $KEYPAIR_FILE ubuntu@$PUBLIC_DNS

  if [ $? -ne 0 ]; then 
    echo "Please check your config and try again."
    exit $?
  fi

  # remove node.json
  rm -f $node_json

  echo ==========================================================
  echo "User has been created."
  echo "username:  focus"
  echo "You can login to server by  ssh focus@"$PUBLIC_DNS" now"
  echo ==========================================================
}



read -p "Do you want to create new ec2 instance? [Yy/Nn]" answer
case "$answer" in 
  [yY])  
    create_instance 
    if_created_instance
    create_user
    echo $INSTANCE_ID > $INSTANCE_ID_FILE
    echo $PUBLIC_DNS > $INSTANCE_PUB_DNS_FILE
    ;;
  *);;
esac 
