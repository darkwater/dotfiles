alias watchdir='watch -tcn 1 tree -C'

function multiscreen
    xrandr --output VGA1 --auto
    xrandr --output VGA1 --left-of LVDS1
    nitrogen --restore
end

if test (uname -a | grep -ie arch -e manjaro)
    alias get='sudo pacman -S'
    alias search='pacman -Ss'
    alias show='pacman -Si'
    alias update='pacman -Sy'
    alias upgrade='pacman -Syyuu'
else
    alias get='sudo apt-get install'
    alias search='apt-cache search'
    alias show='apt-cache show'
    alias update='sudo apt-get update'
    alias upgrade='sudo apt-get upgrade'
end

function irssi
    ssh nv -t 'screen -xUS irssi; or screen -US irssi /usr/bin/irssi'
    clear
end

function snv
    ssh nv -t 'tmux a; or tmux; or /usr/bin/fish'
end

function gitlog
    git log --graph \
            --abbrev-commit \
            --decorate \
            --date=relative \
            --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset)'\t'%C(white)%s%C(reset) %C(bold black)- %an%C(reset)%C(bold yellow)%d%C(reset)' \
            --all
end

function ll
    if test "$PWD" = "$HOME" -o "$argv" = "$HOME"
        ls -hlF --group-directories-first $argv
        return
    end
    ls -halF --group-directories-first $argv
end


set prompt_show_hostname no
switch (hostname)
    case dark-desktop
        set prompt_color 00aa00
    case dark-laptop
        set prompt_color 2266ff
    case novaember
        set prompt_color ffaf00
    case '*'
        set prompt_color ababab
        set prompt_show_hostname yes
end

function fish_prompt_separator
    set_color ababab
    echo -n ' // '
end

function fish_prompt
    set -l last_status $status

    echo -n ' '

    if [ $last_status -ne 0 ]
        set_color ff6622
        echo -n $last_status

        fish_prompt_separator
    end

    set_color $prompt_color
    echo -n (whoami)

    fish_prompt_separator

    if test $prompt_show_hostname = yes
        set_color $prompt_color
        echo -n (hostname)

        fish_prompt_separator
    end

    set_color efefef
    echo -n (prompt_pwd)

    fish_prompt_separator
end

function fish_right_prompt_DEACTIVATED
    if [ -z $TMUX ]
        fish_prompt_separator
        set_color aaafff
        echo -n (w | grep -oE '[0-9.]+, [0-9.]+, [0-9.]+')

        fish_prompt_separator
        set_color 00afff
        echo -n (date +'%H:%M')

        echo ' '
    end
end

function cut_pad
    if [ (count $argv) -lt 2 ]; return; end

    set -l res (echo "$argv[2]" | cut -c -$argv[1])
    set -l len (echo "$argv[2]" | wc -c)

    set -l res (printf '%-*s\n' $argv[1] $res[1])

    echo $res[1]
end

function floor
    printf '%.0f\n' (math "$argv[1] - ($argv[1] % 1)")
end

function print_row
    set -l length (count $argv)
    set -l width (math 'scale=2; '(tput cols)'/'$length)

    for str in $argv
        echo -n (cut_pad (floor $width) $str)
    end
    echo
end

function fish_greeting
    set -l FPS (fish_prompt_separator)

    echo '        '$FPS(hostname)
    echo '       '$FPS(date +'%a %b %d %H:%M:%S')
    echo '      '$FPS(fortune -s -n (math (tput cols)'- 15') ~/dotfiles/fortunes.txt)
end


stty stop '' -ixon -ixoff


set TERM xterm-256color
set PATH ~/bin $PATH ~/.gem/ruby/2.0.0/bin
set EDITOR /usr/bin/vim
set GREP_COLOR '38;5;214;48;5;236'
