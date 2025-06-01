#!/bin/bash

out="$(curl -s 'http://localhost:9090/api/v1/query' \
    --url-query 'query=(delta(node_power_supply_charge_ampere[30s])*120)*node_power_supply_voltage_volt' |
    jq -r '.data.result[0].value[1] | tonumber | round')"

if [[ "$out" != "0" ]]; then
    echo "$out"
fi
