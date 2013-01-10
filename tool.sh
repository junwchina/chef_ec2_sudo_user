#!/bin/bash 

# exit status
NO_HOST_EXIT=1

function get_pub_dns {
  if [ -f $INSTANCE_PUB_DNS_FILE ]; then 
    pub_dns=$(cat $INSTANCE_PUB_DNS_FILE)
  else 
    if [ -n $1 ]; then 
        pub_dns=$1
    else 
        return $NO_HOST_EXIT
    fi
  fi
  echo $pub_dns
}
