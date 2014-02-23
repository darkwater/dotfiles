#!/usr/bin/fish

set load (ssh nv "uptime | grep -oE '[0-9.]+, [0-9.]+, [0-9.]+' | cut -d',' -f2 | xargs")
echo "$load" > /tmp/vps_load

set viewers (ssh nv "netstat -nt | grep 'ESTABLISHED' | grep -c 81.4.121.34:1337")
echo "$viewers" > /tmp/stream_viewers
