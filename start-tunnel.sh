#!/bin/bash

# Resolve wireguard's container IP
WIREGUARD_IP=`getent hosts wireguard | awk '{ print $1 }'`

# Start server
# ./wstunnel -v --udp --server wss://0.0.0.0:443 -r wireguard:51820
./wstunnel -v --server wss://0.0.0.0:443 -r $WIREGUARD_IP:51820

