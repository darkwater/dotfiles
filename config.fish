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

function fish_right_prompt
    
end


stty stop '' -ixon -ixoff


set TERM xterm-256color
set PATH ~/bin $PATH
set GREP_COLOR '30;48;5;221'
