alias ll='ls -halF --group-directories-first'
alias watchdir='watch -tcn 1 tree -C'

if test (uname -a | grep -ie arch -e manjaro)
    alias get='sudo apt-get install'
    alias search='apt-cache search'
    alias show='apt-cache show'
end

function irssi
    ssh novaember.com -t 'screen -xUS irssi; or screen -US irssi irssi'
    sleep 1s
    irssi
end

function snv
    ssh novaember.com -t 'tmux a; or tmux; or /usr/bin/fish'
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
set PATH ~/bin $PATH
set GREP_COLOR '38;5;214;48;5;236'
