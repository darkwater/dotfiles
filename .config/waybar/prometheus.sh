#!/bin/bash

declare -A QUERY

delta_time="2m"

QUERY["battery_discharge"]="avg_over_time(node_power_supply_current_ampere[$delta_time]) * avg_over_time(node_power_supply_voltage_volt[$delta_time])"
QUERY["battery_charge"]="clamp_min(delta(node_power_supply_charge_ampere[$delta_time]), 0) * 30 * avg_over_time(node_power_supply_voltage_volt[$delta_time])"
QUERY["power_supply_rate"]="${QUERY[battery_discharge]} + ${QUERY[battery_charge]}"

query="${QUERY[$1]}"

curl -s 'http://localhost:9090/api/v1/query' \
  --data-urlencode "query=$query" | jq -r '.data.result[0].value[1]'
