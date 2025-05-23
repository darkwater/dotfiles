#!/bin/bash

case "$(hostname)" in
  "tetsuya")
    xrandr --output DP-1 --primary
    ;;
  "nagumo")
    pkill hypridle
    hyprctl keyword general:gaps_out 13,18,0,19
    ;;
  "holo")
    hyprctl keyword general:gaps_out 10,10,0,10
    hyprctl keyword general:border_size 1
    hyprctl keyword general:col.active_border "rgba(f63d28ee) rgba(f65643ee) 45deg"
    ;;
esac
