#!/bin/bash

check_ip() {
    local host_name=$1
    local ip_to_check=$2
    local dns_server=$3

    resolved_ip=$(nslookup "$host_name" "$dns_server" 2>/dev/null | awk '/^Address: / {print $2}' | head -n 1)

    if [[ "$resolved_ip" != "$ip_to_check" && -n "$resolved_ip" ]]; then
        echo "Bogus IP for $host_name in /etc/hosts! Expected: $ip_to_check, Got: $resolved_ip"
    fi
}

cat /etc/hosts | while read -r line; do
    if [[ "$line" =~ ^#.* ]] || [[ -z "$line" ]]; then
        continue
    fi

    ip=$(echo "$line" | awk '{print $1}')
    name=$(echo "$line" | awk '{print $2}')

    dns_server="8.8.8.8"

    check_ip "$name" "$ip" "$dns_server"
done
