#!/usr/bin/fish


rm /tmp/info_panel ^&-
touch /tmp/info_panel

for i in (seq (xrandr --current | grep -cE '\bconnected\b'))
    tail -f /tmp/info_panel | dzen2         \
         -x  (math "820 + ($i-1) * 1920")   \
         -y  1058                           \
         -bg '#1d1f21'                      \
         -tw 1100                           \
         -ta r                              \
         -h  24                             \
         -fn 'Droid Sans Mono:size=10'      \
         -p                                 &
end


function clock ; echo '#fa0' ; echo 'clock'
    echo (date +'%a %b %d %H:%M:%S')
end

function host ; echo '#ff0' ; echo 'arch_10x10'
    echo (hostname)
end

function disk ; echo '#ff0' ; echo 'diskette'
    echo (df -h --output=avail ~ | tail -n 1 | tr -d ' ')
end

function load ; echo '#af0' ; echo 'cpu'
    echo (uptime | grep -oE '[0-9.]+, [0-9.]+, [0-9.]+' | cut -d' ' -f2 | sed 's/[, ]//g')
end

function volume
    set volume (amixer sget Master | grep -oE '\[1?[0-9]{1,2}%\]' | grep -oE '[0-9]+')
    set mute (amixer sget Master | grep -oE '\[(on|off)\]' | grep -oE '[onf]+')

    if [ "$mute" = "on" ] # NOT muted
        set fg '#0f4'
        set bg '#052'
    else
        set fg '#aaa'
        set bg '#444'
    end

    echo $fg
    echo 'spkr_01'

    echo $volume | gdbar -fg $fg -bg $bg -h 2 -sw 6 -ss 2
end

function mpd
    set now_playing (mpc -h 'mpd' -f '[%title%]|[%file%]')
    if [ $status -ne 0 ]; return; end

    echo "$now_playing[2]" | grep '\[playing\]' ^/dev/null >/dev/null
    if [ $status -eq 0 ]
        echo '#0fa'
    else
        echo '#aaa'
    end

    set volume (math '('(echo $now_playing[3] | grep -oE '[0-9]+')' - 60) * 100 / 40')
    set now_playing (basename -s'.mp3' $now_playing[1] | sed -re's/\(.*\)//g' -e's/^ +| +$|^.* – //g' | grep -oE '.{1,45}')

    echo 'note'

    echo -n $now_playing[1] '@' $volume'%'
end

function mpd_volume
    set now_playing (mpc -h 'mpd')
    if [ $status -ne 0 ]; return; end

    echo "$now_playing[2]" | grep '\[playing\]' ^/dev/null >/dev/null
    if [ $status -eq 0  ] # playing
        set fg '#0fa'
        set bg '#054'
    else
        set fg '#aaa'
        set bg '#444'
    end

    echo $fg
    echo 'note'

    echo -n (math (echo $now_playing[3] | grep -oE '[0-9]+') - 60 | gdbar -max 40 -fg $fg -bg $bg -h 2 -sw 6 -ss 2)
end

function battery ; echo '#0ff' ; echo 'bat_low_02'
    if ls /sys/class/power_supply/BAT/capacity ^/dev/null >/dev/null
        cat /sys/class/power_supply/BAT/capacity | gdbar -fg '#0ff' -bg '#055' -h 2
    end
end


touch /tmp/info_panel_update

while true
    begin
        set items
        function add_item
            if [ (count $argv) -ne 3 ]; return; end
            set items "^fg($argv[1]) ^i(/home/dark/.icons/sm4tik/xbm/$argv[2].xbm) $argv[3] " $items
        end



        add_item (clock)
        add_item (disk)
        add_item (load)
        add_item (volume)
        add_item (mpd_volume)
        add_item (battery)


        for i in $items
            echo -n "^bg()^fg(#707070)\\\\$i"
        end

        echo
    end >>/tmp/info_panel

    # 0.(math 1000000000 - (date +'%N'))

    inotifywait -e close_write -t 1 /tmp/info_panel_update ^/dev/null >/dev/null

    if [ $status -eq 1 ]; exit; end
end
