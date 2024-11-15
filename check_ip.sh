#!/bin/bash

# Florin Venis

cat /etc/hosts | while read -r line; do
    if [[ "$line" =~ ^#.* ]] || [[ -z "$line" ]]; then
        continue
    fi

    ip=$(echo "$line" | awk '{print $1}')
    name=$(echo "$line" | awk '{print $2}')

    resolved_ip=$(nslookup "$name" 2>/dev/null | awk '/^Address: / {print $2}' | head -n 1)

    if [[ "$resolved_ip" != "$ip" && -n "$resolved_ip" ]]; then
        echo "Bogus IP for $name in /etc/hosts!"
    fi
done
