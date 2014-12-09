HISTFILE=~/.zhistory
HISTSIZE=1000
SAVEHIST=10000

setopt appendhistory autocd beep notify
unsetopt extendedglob nomatch

bindkey -e

zstyle :compinstall filename '/home/dark/.zshrc'

autoload -Uz compinit
compinit


stty stop '' -ixon -ixoff


test "$TERM" = "xterm" && TERM=xterm-256color
test "$TERM" = "screen" && TERMs=screen-256color
set PATH ~/bin $PATH /opt/android-sdk/platform-tools /opt/android-sdk/tools ~/.gem/ruby/1.0.0/bin
set EDITOR /usr/bin/vim
set GREP_COLOR '38;5;214;48;5;236'


if test (uname -a | grep -ie arch -e manjaro); then
    alias get='yaourt -S'
    alias search='yaourt -Ss'
    alias show='yaourt -Si'
    alias update='yaourt -Sy'
    alias upgrade='yaourt -Syyuua'
    alias remove='yaourt -R'
else
    alias get='sudo apt-get install'
    alias search='apt-cache search'
    alias show='apt-cache show'
    alias update='sudo apt-get update'
    alias upgrade='sudo apt-get upgrade'
    alias remove='sudo apt-get remove'
    alias purge='sudo apt-get purge'
fi

function irssi
{
    ssh nv -t 'screen -xUS irssi; or screen -US irssi /usr/bin/irssi'
}

function snv
{
    ssh nv -t 'tmux a; or tmux; or /usr/bin/fish'
}

function gitlog
{
    git log --graph \
            --abbrev-commit \
            --decorate \
            --date=relative \
            --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset)'\t'%C(white)%s%C(reset) %C(bold black)- %an%C(reset)%C(bold yellow)%d%C(reset)' \
            --all
}

function ll
{
    if test "$PWD" = "$HOME" -o "$1" = "$HOME"; then
        ls -hlF --group-directories-first $argv
        return
    fi

    ls -halF --group-directories-first $argv
}


prompt_show_hostname=no
case `hostname`; in
    dark-desktop) prompt_color=00aa00 ;;
     dark-laptop) prompt_color=2266ff ;;
       novaember) prompt_color=ffaf00 ;;
          sinuss) prompt_color=8700d7 ;;
               *) prompt_color=ababab
                  prompt_show_hostname=yes ;;
esac

function floor
{
    printf '%.0f\n' (math "$1 - ($1 % 1)")
}

if test "$TERM" = "linux"; then
    echo -en "\e]P0070809" #black
    echo -en "\e]P1cd0000" #darkred
    echo -en "\e]P200cd00" #darkgreen
    echo -en "\e]P3b8b800" #brown
    echo -en "\e]P41e90ff" #darkblue
    echo -en "\e]P5cd00cd" #darkmagenta
    echo -en "\e]P600cdcd" #darkcyan
    echo -en "\e]P7e5e5e5" #lightgrey
    echo -en "\e]P84c4c4c" #darkgrey
    echo -en "\e]P9ff0000" #red
    echo -en "\e]PA00ff00" #green
    echo -en "\e]PBffff00" #yellow
    echo -en "\e]PC4682b4" #blue
    echo -en "\e]PDff00ff" #magenta
    echo -en "\e]PE00ffff" #cyan
    echo -en "\e]PFffffff" #white
    clear #for background artifacting
fi
