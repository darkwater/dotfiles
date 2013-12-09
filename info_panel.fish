#!/usr/bin/fish


rm /tmp/info_panel ^&-
touch /tmp/info_panel

for i in (seq (xrandr --current | grep -cE '\bconnected\b'))
    tail -f /tmp/info_panel | dzen2         \
         -x  (math "820 + ($i-1) * 1920")   \
         -y  1057                           \
         -bg '#1d1f21'                      \
         -tw 1100                           \
         -ta r                              \
         -h  23                             \
         -fn 'Droid Sans Mono:size=10'      \
         -p                                 &
end


while true
    begin
        set items
        function add_item
            set items "^fg($argv[1]) $argv[2] " $items
        end


        add_item '#fa0' (date +'%a %b %d %H:%M:%S')
        add_item '#af0' (w | grep -oE '[0-9.]+, [0-9.]+, [0-9.]+' | cut -d' ' -f3)


        for i in $items
            echo -n "^bg()^fg(#707070)\\\\$i"
        end

        echo
    end >>/tmp/info_panel

    sleep 1s
end
