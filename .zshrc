HISTFILE=~/.zhistory
HISTSIZE=10000
SAVEHIST=100000

export PATH="~/.cargo/bin:~/bin:~/dotfiles/bin:$PATH:/usr/sbin:/sbin"

if command -v cope_path > /dev/null; then
    export PATH=$(cope_path):$PATH
fi

setopt appendhistory autocd notify hist_ignore_all_dups hist_ignore_space
unsetopt extendedglob nomatch beep

bindkey -v

zstyle :compinstall filename ~/.zshrc
zstyle ':completion:*' matcher-list 'm:{A-ZÄÖÜÉÈËa-zäöüéèë}={a-zäöüéèëA-ZÄÖÜÉÈË}' '+l:|=*'
zstyle ':completion::complete:*' use-cache 1

autoload -Uz compinit promptinit
compinit
promptinit; prompt gentoo


stty stop '' -ixon -ixoff


test "$TERM" = "xterm" && export TERM=xterm-256color
test "$TERM" = "screen" && export TERM=screen-256color

export EDITOR=/usr/bin/nvim
export GREP_COLOR='38;5;214;48;5;236'
export RI="-Tf ansi -d doc"

bindkey '^[[1;5D' emacs-backward-word
bindkey '^[[1;5C' emacs-forward-word
bindkey '^[[H'    beginning-of-line
bindkey '^[[4~'   end-of-line
bindkey '^[[P'    delete-char


if command -v pacaur > /dev/null; then
    alias get='pacaur -S'
    alias search='pacaur -Ss'
    alias show='pacaur -Si'
    alias update='pacaur -Sy'
    alias upgrade='pacaur -Syu'
    alias remove='pacaur -R'
elif command -v pacman > /dev/null; then
    alias get='sudo pacman -S'
    alias search='pacman -Ss'
    alias show='pacman -Si'
    alias update='sudo pacman -Sy'
    alias upgrade='sudo pacman -Syu'
    alias remove='sudo pacman -R'
elif command -v apt-get > /dev/null; then
    alias get='sudo apt-get install'
    alias search='apt-cache search'
    alias show='apt-cache show'
    alias update='sudo apt-get update'
    alias upgrade='sudo apt-get upgrade'
    alias remove='sudo apt-get remove'
    alias purge='sudo apt-get purge'
else
    echo 'Warning! No package manager found for get/upgrade/... aliases.'
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
    printf '\x1b]710;%s%d\x07' 'xft:Roboto Mono:size=' "$1"
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
    window_title="${USER}@$(hostname): ${PWD}"

    local ref=$(git symbolic-ref HEAD 2> /dev/null)
    local attached=true
    if [[ -z "$ref" ]]; then
        ref=$(git rev-parse --short HEAD 2> /dev/null)
        attached=false
    fi

    if [[ -n "$ref" ]]; then

        if [[ "$attached" = false ]]; then
            echo -n "%{$fg[red]%}"
        elif [[ "$(git status --porcelain)" != "" ]]; then
            echo -n "%{$fg[yellow]%}"
        else
            echo -n "%{$fg[green]%}"
        fi

        # Repository name @ branch
        echo -n "[${ref#refs/heads/}] $(basename "$(git rev-parse --show-toplevel)")"
        window_title="${window_title} [${ref#refs/heads/}]"

        # Internal path (relative to repository root)
        echo -n "%{$fg[blue]%}/$(git rev-parse --show-prefix)"

    else

        # Current working directory
        echo -n "%{$fg[blue]%}%~"

    fi

    # Shell $ prompt sign
    echo -n " %{$reset_color%}$ "

    # Bell and window title set
    echo -n "%{\a\e]0;$window_title\a%}"
}

function preexec()
{
    cmd=$(echo "$2" | tr -d '\000-\037')
    echo -n "\e]0;${USER}@$(hostname): ${PWD} $ $cmd\a"
}


source ~/dotfiles/zshplugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
