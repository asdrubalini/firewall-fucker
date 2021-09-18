#!/bin/bash

# Resolve wireguard's container IP
WIREGUARD_IP=`getent hosts wireguard | awk '{ print $1 }'`

# Start server
./udp2raw_amd64 -s -l0.0.0.0:443 -r $WIREGUARD_IP:51820 -k "password" --raw-mode faketcp -a

