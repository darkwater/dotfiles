#!/bin/bash

hostname="$(hostname)"

PATH="$HOME/.local/bin:$HOME/dotfiles/bin:$HOME/.cargo/bin:$PATH"
export PATH

launch() {
    ( "$@" )&
}

if [[ "$1" = "once" ]]; then
    # AUTOSTART
    launch hyprpaper
    launch hyprpm reload
    launch autorestart waybar
    launch autorestart wvkbd-mobintl --hidden

    if [[ "$hostname" = "tetsuya" ]]; then
        launch hypridle
        sleep 5s; launch openrgb -p pride
    fi

    if [[ "$hostname" = "nagumo" ]]; then
        launch autorestart ~/.cargo/bin/fprint-prompt
    fi

    if [[ "$hostname" != "holo" ]]; then
        launch /opt/activitywatch/aw-server/aw-server
        launch aw-watcher-window-wayland

        random-wallpaper

        sleep 0; launch gtk-launch zen
        sleep 2; launch gtk-launch vesktop
        sleep 5; launch gtk-launch org.telegram.desktop.desktop
        # sicshark-2
    else
        (
            sleep 2
            hyprctl hyprpaper preload /home/dark/holo.jpg
            hyprctl hyprpaper wallpaper ,/home/dark/holo.jpg
        )
    fi

    sleep 10s; ddcutil -d 1 setvcp 10 100; sleep 1s; ddcutil -d 2 setvcp 10 100
else
    case "$(hostname)" in
    "tetsuya")
        xrandr --output DP-1 --primary
        ( sleep 10 && xrandr --output DP-1 --primary) &
        ( sleep 20 && xrandr --output DP-1 --primary) &
        ( sleep 30 && xrandr --output DP-1 --primary) &
        ( sleep 1m && xrandr --output DP-1 --primary) &
        ( sleep 2m && xrandr --output DP-1 --primary) &
        ( sleep 5m && xrandr --output DP-1 --primary) &
        ;;
    "nagumo")
        pkill hypridle
        hyprctl keyword general:gaps_out 13,18,0,19
        ;;
    "holo")
        hyprctl keyword general:gaps_in 1
        hyprctl keyword general:gaps_out 0
        hyprctl keyword general:border_size 1
        hyprctl keyword decoration:rounding 0
        hyprctl keyword general:col.active_border "rgba(f63d28ee) rgba(f65643ee) 45deg"
        ;;
    esac
fi
