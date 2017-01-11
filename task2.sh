#!/bin/bash

echo "Enumerating hosts.."
ip_addrs=($(nmap -sn -PS --scan-delay 250ms --max-rate 4 --max-retries 0 -oG - 192.168.3.0/24 | awk '$5=="Up" {print $2,"\n"}'))

for ((i = 0; i < ${#ip_addrs[@]}; i+=2)); do
  nmap -Pn --disable-arp-ping -sS --scan-delay 250ms --max-rate 8 --max-retries 0 -n -p T:21,22,23,53,79,80,123 ${ip_addrs[$i]} ${ip_addrs[$i+1]}
  sleep 0.5
done

echo "Port scan finished. 2 IP's scanned at a time, full results above."
