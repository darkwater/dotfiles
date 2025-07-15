#!/usr/bin/env bash
#
# https://chatgpt.com/share/68769ef0-5d3c-800f-b4ef-3829de502987
#
# cycle-audio-output.sh — cycle through non-disabled PulseAudio sinks
# (works under pipewire-pulse too)

set -euo pipefail

# 1) Collect all sinks whose Ports include any “(...)” but NOT “not available”
mapfile -t SINK_LINES < <(
  pactl list sinks | \
  awk 'BEGIN { RS=""; FS="\n" }
    {
      idx=""; name=""; usable=0
      for (i=1; i<=NF; i++) {
        if ($i ~ /^Sink #[0-9]+/) {
          sub(/^Sink #/, "", $i); idx = $i + 0
        }
        else if ($i ~ /^[[:space:]]*Name:[[:space:]]+/) {
          sub(/^[[:space:]]*Name:[[:space:]]+/, "", $i); name = $i
        }
        else if ($i ~ /\([^)]*\)/ && $i !~ /not available/) {
          usable = 1
        }
      }
      if (usable && idx != "" && name != "") {
        print idx, name
      }
    }'
)

(( ${#SINK_LINES[@]} )) || {
  echo "Error: no available sinks found." >&2
  exit 1
}

# 2) Split into parallel arrays
AVAILABLE_SINKS=()   # numeric IDs
AVAILABLE_NAMES=()   # pulse sink names
for line in "${SINK_LINES[@]}"; do
  AVAILABLE_SINKS+=( "${line%% *}" )
  AVAILABLE_NAMES+=( "${line#* }"   )
done

# 3) Detect current default’s position
DEFAULT_NAME=$(pactl info | awk -F': ' '/^Default Sink/ {print $2}')
CURRENT_POS=-1
for i in "${!AVAILABLE_NAMES[@]}"; do
  [[ "${AVAILABLE_NAMES[i]}" == "$DEFAULT_NAME" ]] && { CURRENT_POS=$i; break; }
done

# 4) Compute next index (wrap around)
if (( CURRENT_POS < 0 )); then
  NEXT_POS=0
else
  NEXT_POS=$(( (CURRENT_POS + 1) % ${#AVAILABLE_SINKS[@]} ))
fi
NEXT_IDX="${AVAILABLE_SINKS[NEXT_POS]}"
NEXT_NAME="${AVAILABLE_NAMES[NEXT_POS]}"

# 5) Apply: set default and re-route streams
pactl set-default-sink "$NEXT_IDX"
while read -r STREAM_ID; do
  pactl move-sink-input "$STREAM_ID" "$NEXT_IDX"
done < <(pactl list short sink-inputs | cut -f1)

echo "✔ Switched default sink to #$NEXT_IDX ($NEXT_NAME)"

