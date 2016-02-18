HISTFILE=~/.zhistory
HISTSIZE=10000
SAVEHIST=100000

export PATH=~/bin:~/dotfiles/bin:$PATH

if command -v cope_path > /dev/null; then
    export PATH=$(cope_path):$PATH
fi

setopt appendhistory autocd notify hist_ignore_all_dups hist_ignore_space
unsetopt extendedglob nomatch beep

bindkey -e

zstyle :compinstall filename ~/.zshrc
zstyle ':completion:*' matcher-list 'm:{A-ZÄÖÜÉÈËa-zäöüéèë}={a-zäöüéèëA-ZÄÖÜÉÈË} m:[-_.]=[-_.] r:|[-_.]=** r:|=*' '+l:|=*'

autoload -Uz compinit
compinit


stty stop '' -ixon -ixoff


test "$TERM" = "xterm" && export TERM=xterm-256color
test "$TERM" = "screen" && export TERM=screen-256color

export EDITOR=/usr/bin/nvim
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


if command -v pacaur > /dev/null; then
    alias get='pacaur -S'
    alias search='pacaur -Ss'
    alias show='pacaur -Si'
    alias update='pacaur -Sy'
    alias upgrade='pacaur -Syu'
    alias remove='pacaur -R'
else
    alias get='sudo apt-get install'
    alias search='apt-cache search'
    alias show='apt-cache show'
    alias update='sudo apt-get update'
    alias upgrade='sudo apt-get upgrade'
    alias remove='sudo apt-get remove'
    alias purge='sudo apt-get purge'
fi

alias nv="ssh nv" # 6 characters is too much!

function startblog()
{
    nv -tL 3000:localhost:3000 'cd blog && rails s'
}

function ll()
{
    if test \( "$PWD" = "$HOME" -a $# = 0 \) -o "$1" = ~; then
        ls -hlF --color=auto --group-directories-first $argv
        return
    fi

    ls -halF --color=auto --group-directories-first $argv
}

function downloads()
{
    cd ~/downloads/
    ls -hAlt --color=always | head -n 11 | tail | tac
}

function fs()
{
    printf '\x1b]710;%s%d\x07' 'xft:Droid Sans Mono:size=' "$1"
}


if test "$TERM" = "linux"; then
    echo -en "\e]P01D1F21" # black
    echo -en "\e]P1E84F4F" # darkred
    echo -en "\e]P2B8D68C" # darkgreen
    echo -en "\e]P3E1AA5D" # brown
    echo -en "\e]P47DC1CF" # darkblue
    echo -en "\e]P59B64FB" # darkmagenta
    echo -en "\e]P66D878D" # darkcyan
    echo -en "\e]P7dddddd" # lightgrey
    echo -en "\e]P8404040" # darkgrey
    echo -en "\e]P9D23D3D" # red
    echo -en "\e]PAA0CF5D" # green
    echo -en "\e]PBF39D21" # yellow
    echo -en "\e]PC4E9FB1" # blue
    echo -en "\e]PD8542FF" # magenta
    echo -en "\e]PE42717B" # cyan
    echo -en "\e]PFdddddd" # white
    clear # for background artifacting
fi


setopt prompt_subst
setopt promptsubst
setopt promptpercent

autoload colors; colors;

local return_code="%(?..%{$fg[red]%}%? ↵ %{$reset_color%})"

local user_host='%{$fg[green]%}%n@%m%{$reset_color%}'
local current_dir='%{$fg[blue]%}%~%{$reset_color%}'

PROMPT='$(zsh_prompt)'
RPROMPT="%(?..%{$fg[red]%}%? ! %{$reset_color%})%{$fg_bold[black]%}$(hostname)  %T%{$reset_color%}"


function zsh_prompt()
{
    echo -en '%{\a%}'

    local ref=$(git symbolic-ref HEAD 2> /dev/null)
    local attached=true
    if [[ -z "$ref" ]]; then
        ref=$(git rev-parse --short HEAD 2> /dev/null)
        attached=false
    fi

    if [[ -n "$ref" ]]; then

        local repo="$(git rev-parse --show-toplevel)"
        local cwd="$(pwd)"

        if [[ "$repo" = "$cwd" ]]; then
            cwd=$cwd/
        fi

        if [[ "$attached" = false ]]; then
            echo -n "%{$fg[red]%}"
        elif [[ "$(git status 2> /dev/null | tail -n1)" != "nothing to commit, working directory clean" ]]; then
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


source ~/dotfiles/zshplugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
