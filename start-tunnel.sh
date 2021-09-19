#!/bin/bash

# Resolve wireguard's container IP
WIREGUARD_IP=`getent hosts wireguard | awk '{ print $1 }'`

echo $WIREGUARD_IP

# Start server
./wstunnel -v --server wss://0.0.0.0:443 -r $WIREGUARD_IP:51820

