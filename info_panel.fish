#!/usr/bin/fish


set mpd_host localhost


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


while true
    begin
        set items
        function add_item
            set items "^fg($argv[1]) ^i(/home/dark/.icons/sm4tik/xbm/$argv[2].xbm) $argv[3] " $items
        end

        set icons
        function add_icon
            set icons "^fg($argv[1])^i(/home/dark/.icons/sm4tik/xbm/$argv[2].xbm) " $icons
        end


        set volume (amixer sget Master | grep -oE '\[1?[0-9]{1,2}%\]' | grep -oE '[0-9]+')


        add_item '#fa0' 'clock'         (date +'%a %b %d %H:%M:%S')
        add_item '#ff0' 'arch_10x10'    (hostname)
        add_item '#af0' 'cpu'           (uptime | grep -oE '[0-9.]+, [0-9.]+, [0-9.]+' | cut -d' ' -f2 | sed 's/[, ]//g')
        add_item '#0f4' 'spkr_01'       (echo $volume | gdbar -fg '#0f4' -bg '#053' -h 2 -sw 6 -ss 2)
        #add_item '#aaa' 'note'          (mpc -h $mpd_host -f '[%title%]|[%file%]' | head -n 1 | sed -re's/\(.*\)//g' \
        #                                                                                             -e's/^ +| +$//g')
        add_item '#0ff' 'bat_low_02'    (cat /sys/class/power_supply/BAT/capacity | gdbar -fg '#0ff' -bg '#055' -h 2)


        for i in $icons
            echo -n "$i"
        end

        for i in $items
            echo -n "^bg()^fg(#707070)\\\\$i"
        end

        echo
    end >>/tmp/info_panel

    sleep 1s
end
