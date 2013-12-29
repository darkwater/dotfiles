#!/usr/bin/fish

ssh novaember.com "uptime | grep -oE '[0-9.]+, [0-9.]+, [0-9.]+' | cut -d',' -f2 | xargs" > /tmp/vps_load
