#!/bin/bash

if [[ $(swaync-client -D) = true ]]; then
    echo "󰍶 $(swaync-client -c)"
else
    echo "󰂜"
fi
