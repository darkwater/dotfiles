#!/usr/bin/fish

set volume (amixer sget Master | grep -oE '\[1?[0-9]{1,2}%\]' | grep -oE '[0-9]+')

for i in $argv
    switch $i
        case 'toggle'
            mpc play
        case 'next'
            mpc next
        case 'prev'
            mpc prev
        case 'up'
            amixer sset Master (math $volume + 10)'%'
        case 'down'
            amixer sset Master (math $volume - 10)'%'
        case 'mute'
            amixer sset Master toggle
    end
end
