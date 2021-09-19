#!/bin/bash

pre_up () {
    local wg=$1
    local cfg="/etc/wireguard/${wg}.wstunnel"
    local remote remote_ip gw

    if [[ -f "${cfg}" ]]; then
        source "${cfg}"
        remote=${REMOTE_HOST}
    else
        echo "[#] Missing config file: ${cfg}"
        exit 1
    fi

    remote_ip=$(getent hosts "${remote}" | awk '{ print $1 }' | head -1)

    if [[ -z "${remote_ip}" ]]; then
        echo "[#] Can't resolve ${remote}"
        exit 1
    fi

    # Find out current route to ${remote_ip} and make it explicit
    gateway=$(ip route get "${remote_ip}" | cut -d" " -f3)
    ip route add "${remote_ip}" via "${gateway}" > /dev/null 2>&1 || true

    # Launch tunnel
    wstunnel --udpTimeoutSec 60 --udp \
        -L 127.0.0.1:${LOCAL_PORT}:${REMOTE_LOCAL_HOST}:${REMOTE_LOCAL_PORT} \
        wss://${REMOTE_HOST}:${REMOTE_PORT} &

    disown

    # Save state
    mkdir -p /var/run/wireguard
    echo "${remote_ip}" > "/var/run/wireguard/${wg}.wstunnel"
}

post_up () {
    local wg=$1

    ip route add 0.0.0.0/1 dev "${wg}" > /dev/null 2>&1
    ip route add ::0/1 dev "${wg}" > /dev/null 2>&1
    ip route add 128.0.0.0/1 dev "${wg}" > /dev/null 2>&1
    ip route add 8000::/1 dev "${wg}" > /dev/null 2>&1
}

post_down () {
    local wg=$1
    local state_file="/var/run/wireguard/${wg}.wstunnel"
    local remote_ip

    if [[ -f "${state_file}" ]]; then
        read -r remote_ip < "${state_file}"
        rm "${state_file}"
    else
        echo "[#] Missing state file: ${state_file}"
        exit 1
    fi

    pkill -9 wstunnel

    if [[ -n "${remote_ip}" ]]; then
    	ip route delete "${remote_ip}" > /dev/null 2>&1 || true
    fi
}
