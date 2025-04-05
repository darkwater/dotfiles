#!/bin/bash

curl -s 'https://3dp.fbk.red/printer/objects/query?webhooks&virtual_sdcard&print_stats' |
    jq -r '.result.status | "\(.virtual_sdcard.progress * 100 | round) \(.print_stats.print_duration | round) \(.print_stats.total_duration | round)"' |
    {
        read progress duration total
        if [[ -n $progress ]]; then
            progress="$progress%"
            left=$((total - duration))
            now=$(date +%s)
            eta=$((now + left))
            eta=$(date -d @$eta +%H:%M)

            echo "󰹜 $progress"
        fi
    }
