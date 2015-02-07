HISTFILE=~/.zhistory
HISTSIZE=1000
SAVEHIST=10000

setopt appendhistory autocd beep notify hist_ignore_all_dups hist_ignore_space
unsetopt extendedglob nomatch

bindkey -e

zstyle :compinstall filename '/home/dark/.zshrc'

autoload -Uz compinit
compinit


stty stop '' -ixon -ixoff


test "$TERM" = "xterm" && export TERM=xterm-256color
test "$TERM" = "screen" && export TERM=screen-256color

export EDITOR=/usr/bin/vim
export GREP_COLOR='38;5;214;48;5;236'

bindkey '\e[1;5D' emacs-backward-word
bindkey '\e[1;5C' emacs-forward-word
bindkey '\eOd' emacs-backward-word
bindkey '\eOc' emacs-forward-word
bindkey '\e[H' beginning-of-line
bindkey '\e[F' end-of-line
bindkey '\e[7~' beginning-of-line
bindkey '\e[8~' end-of-line
bindkey '\e[3~' delete-char


if test -n "$(uname -a | grep -ie arch -e manjaro 2>/dev/null)"; then
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

alias irssi="ssh nv -t 'screen -xUS irssi || screen -US irssi /usr/bin/irssi'"
alias snv="ssh nv -t 'tmux a || tmux || /usr/bin/fish'"
alias nv="ssh nv" # 6 characters is too much!

alias kb="xset r rate 250 25; xmodmap ~/.xmodmap" # reset keyboard

function px()
{
    cd ~/projects/xedroid
    clear
    git st
}

function pa()
{
    cd ~/projects/almanapp-android
    clear
    git st
    export JAVA_HOME=/usr/lib/jvm/java-7-jdk/
    export SBT_OPTS=-XX:MaxPermSize=2048m
    alias run="ruby build.rb 0000-designtest run"
}

function ll()
{
    if test "$PWD" = "$HOME" -o "$1" = "$HOME"; then
        ls -hlF --color=auto --group-directories-first $argv
        return
    fi

    ls -halF --color=auto --group-directories-first $argv
}


if test "$TERM" = "linux"; then
    echo -en "\e]P0070809" # black
    echo -en "\e]P1cd0000" # darkred
    echo -en "\e]P200cd00" # darkgreen
    echo -en "\e]P3b8b800" # brown
    echo -en "\e]P41e90ff" # darkblue
    echo -en "\e]P5cd00cd" # darkmagenta
    echo -en "\e]P600cdcd" # darkcyan
    echo -en "\e]P7e5e5e5" # lightgrey
    echo -en "\e]P84c4c4c" # darkgrey
    echo -en "\e]P9ff0000" # red
    echo -en "\e]PA00ff00" # green
    echo -en "\e]PBffff00" # yellow
    echo -en "\e]PC4682b4" # blue
    echo -en "\e]PDff00ff" # magenta
    echo -en "\e]PE00ffff" # cyan
    echo -en "\e]PFffffff" # white
    clear # for background artifacting
fi


setopt prompt_subst
setopt promptsubst
setopt promptpercent

autoload colors; colors;

local return_code="%(?..%{$fg[red]%}%? ↵ %{$reset_color%})"

local user_host='%{$fg[green]%}%n@%m%{$reset_color%}'
local current_dir='%{$fg[blue]%}%~%{$reset_color%}'

local git_branch='$(git_prompt_info)%{$reset_color%}'

# PROMPT="%{$fg[yellow]%}%T%{$reset_color%} ${return_code}%{$reset_color%}${current_dir}${git_branch} $ %B%b"

PROMPT='$(zsh_prompt)'
RPROMPT="%(?..%{$fg[red]%}%? ↵ %{$reset_color%})%{$fg_bold[black]%}$(hostname)  %T%{$reset_color%}"


function zsh_prompt()
{
    # Time
    # echo -n "%{$fg_bold[black]%}%T%{$reset_color%} "

    # Return code
    # echo -n "%(?..%{$fg[red]%}%? ↵ %{$reset_color%})"

    local ref=$(git symbolic-ref HEAD 2> /dev/null)
    if [[ -n "$ref" ]]; then

        local repo="$(git rev-parse --show-toplevel)"
        local cwd="$(pwd)"

        if [[ "$repo" = "$cwd" ]]; then
            cwd=$cwd/
        fi

        if [[ "$(git status 2> /dev/null | tail -n1)" != "nothing to commit, working directory clean" ]]; then
            echo -n "%{$fg[yellow]%}"
        else
            echo -n "%{$fg[green]%}"
        fi

        # Repository name @ branch
        echo -n "[${ref#refs/heads/}] $(basename "$repo")"

        # Internal path (relative to repository root)
        echo -n "%{$fg[blue]%}${cwd#$repo}"

    else

        # Current working directory
        echo -n "%{$fg[blue]%}%~"

    fi

    # Shell $ prompt sign
    echo -n " %{$reset_color%}$ "
}


function git_prompt_info()
{
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    if [[ $((git status 2> /dev/null) | tail -n1) != "nothing to commit, working directory clean" ]]; then
        echo -n "%{$fg[yellow]%}"
    else
        echo -n "%{$fg[green]%}"
    fi
    echo " [${ref#refs/heads/}]%{$reset_color%}"
}


source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

uptime
acpi 2>/dev/null
df -h /dev/sd?? | grep -v "^dev"
