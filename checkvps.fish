#!/usr/bin/fish

set load (ssh nv "uptime | grep -oE '[0-9.]+, [0-9.]+, [0-9.]+' | cut -d',' -f2 | xargs")
echo "$load" > /tmp/vps_load
