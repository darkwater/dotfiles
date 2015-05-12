#!/bin/sh

SCREEN=($(bspc query -T | grep '^\S.*\*$' | grep -o '[[:digit:]]*x[[:digit:]]*' | tr 'x' ' '))

dmenu_run -w $((SCREEN[0] * 60 / 100)) -x $((SCREEN[0] * 20 / 100)) -y $((SCREEN[1] * 50 / 100)) \
    -l 10 -fn 'Droid Sans Mono-10' -p '$'
