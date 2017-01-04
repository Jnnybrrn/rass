#!/bin/bash

IP_ADDRS=()
declare -A TIMES
PORTS=(21 22 23 53 79 80 123)
for i in {1..254}; do IP_ADDRS+=('192.168.3.'$i); done
HOST_INDEX=0
PORTS_INDEX=0

# HERE STARTS SPOOFING
function nmapConn {

  if [ -z $2 ]; then
    # no port sent.. meaning we now need to jump HOST & reset PORTS.
    ((HOST_INDEX++))
    if [ $HOST_INDEX -gt 253 ]; then break; fi
    PORTS_INDEX=0
    set -- ${IP_ADDRS[$HOST_INDEX]} ${PORTS[$PORTS_INDEX]}
  fi

  echo "Sending request to $1 for port $2"
  ((PORTS_INDEX++))
}

while true; do
  for client in ${IP_ADDRS[@]}; do
    CURR_TIME=$(($(date +%s%N)/1000000))
    if [ -z ${TIMES[$client]} ]; then
      TIMES[$client]=$CURR_TIME
    else
      DIFF=$(($CURR_TIME-${TIMES[$client]}))
      if [ $DIFF -lt 500 ]; then
        echo "***************************** TOO QUICK ************************"
      fi
    fi
    echo "Acting as client $client..";

    # We're done.
    if [ $HOST_INDEX -gt 253 ]; then
      break 2
    fi
    for i in 1 2; do
      nmapConn ${IP_ADDRS[$HOST_INDEX]} ${PORTS[$PORTS_INDEX]}
    done
  done
done

# HERE STARTS NO SPOOFING
