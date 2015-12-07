#!/bin/bash

summary="$2"
body=$(perl -pe 's|<span.*?>(.*?)</span>|\1|g' <<< "$3")

notify-send "$summary" "$body"
