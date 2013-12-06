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


stty stop '' -ixon -ixoff


set TERM xterm-256color
set PATH ~/bin $PATH
