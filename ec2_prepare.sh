#!/bin/bash 
#
# ./ec2_prepare.sh [host]
#



# load config 
source config.sh

# load tool
source tool.sh

DEFAULT_NODE_JSON=./nodes/default.json

pub_dns=$(get_pub_dns $1)


if [ "$pub_dns" == "" ]; then 
  echo "Please pass a ec2 hostname as the first argument"
  exit $NO_HOST_EXIT
else
  # create node.json if it is not exist
  node_json=./nodes/"$pub_dns".json
  if [ ! -f  node_json ]; then 
    cp $DEFAULT_NODE_JSON $node_json
  fi
    
  knife prepare -i $KEYPAIR_FILE ubuntu@$pub_dns
fi


