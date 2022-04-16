setopt append_history
setopt auto_cd
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt nomatch
setopt notify
setopt prompt_subst
unsetopt beep

export PATH="$HOME/dotfiles/bin:$PATH"

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

alias g="git"
alias s="ssh"
alias x="cargo xtask"

alias sysa="sysz -s active"
alias scu="systemctl --user"
alias ssc="sudo systemctl"
alias svim="sudo nvim"
alias sps="sudo pacman -S"
alias spsyu="sudo pacman -Syu"
alias pss="pacman -Ss"
alias psi="pacman -Si"
alias pql="pacman -Ql"
alias sai="sudo apt install"
alias apts="apt search"

alias ip="ip --color=auto"

exists() { command -v $1 >/dev/null }
exists exa && alias ls=exa

l() {
    # -aa only in $HOME and without arguments
    aa="$([[ "$(pwd)" = "$HOME" && "$#" = 0 ]] || echo -n aa)"
    ls -Flg$aa --group-directories-first "$@"
}

sl() {
    # ls -aa only in $HOME and without arguments
    aa="$([[ "$(pwd)" = "$HOME" && "$#" = 0 ]] || echo -n aa)"
    if exists exa; then
        sudo exa -Flg$aa --group-directories-first "$@"
    else
        sudo ls -Flg$aa --group-directories-first "$@"
    fi
}

downloads() {
    cd ~/?ownloads/
    ls -Fal -tcreated --color=always | head -n 11 | tail | tac
}

man() {
    nvim +"Man $*" +only
}

autoload -Uz compinit promptinit colors
compinit
promptinit
colors

bindkey -e
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[H"    beginning-of-line
bindkey "^[[F"    end-of-line
bindkey "^[[4~"   end-of-line
bindkey "^[[3~"   delete-char
bindkey "^[[P"    delete-char
bindkey "^V"      vi-cmd-mode
stty stop "" -ixon -ixoff

# like ^W but for path segments
backward-kill-dir () {
    local WORDCHARS="\\ ${WORDCHARS/\/}"
    zle backward-kill-word
}
zle -N backward-kill-dir
bindkey '^[w' backward-kill-dir

export EDITOR="nvim"

# program settings
export GREP_COLORS='sl=:cx=38;5;242:rv:mt=38;5;214'
export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;40:st=37;44:ex=01;32:'

# tty colorscheme
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
fi


# prompt
hostname_color() {
    case "$1" in
        tetsuya) echo -n "\e[1;38;2;159;204;225;48;2;27;27;38m"   ;;
        nagumo)  echo -n "\e[1;38;2;206;16;21;48;2;36;28;22m"     ;;
        fubuki)  echo -n "\e[1;38;2;250;250;250;48;2;81;114;142m" ;;
        sinon)   echo -n "\e[1;38;2;196;252;227;48;2;48;42;3m"    ;;
        *)       echo -n "\e[1;38;2;200;200;200;48;2;50;50;50m"   ;;
    esac
}

function set_window_title() {
    echo -n "\e]0;$*\a"
}

genps1() {
    local nl=$'\n'
    local bred=$'%{\e[1;31m%}'
    local green=$'%{\e[32m%}'
    local blue=$'%{\e[34m%}'
    local aqua=$'%{\e[36m%}'
    local reset=$'%{\e[0m%}'

    # bell and window title set
    echo -n "%{\a"
    set_window_title "${USER}@$(hostname): ${PWD}"
    echo -n "%}"

    echo
    [[ -n "$ZSH_PROMPT_AUR_PKG" ]] && echo -n "%{\e[33;1m%}[$ZSH_PROMPT_AUR_PKG] "
    echo -n "%{\e]133;A\a$(hostname_color "$(hostname)")%} %m $reset"

    if [[ "$(whoami)" != "dark" ]]; then
        echo -n " ${bred}[%n]$reset"
    fi

    echo -n " $blue%~"
    echo -n "%(!.$bred # .$aqua %{\xe2\x97%}\x86 )$reset"
}
PS1="$(genps1)"

preexec() {
    preexec_called=1

    cmd="$(echo "$2" | tr -d '\000-\037')"
    set_window_title "${USER}@$(hostname): ${PWD} $ $cmd"
}
precmd() {
    local exit_status="$?"
    if [ "$exit_status" != 0 ] && [ "$preexec_called" = 1 ]
    then echo "\e[1;31mexit $exit_status\e[0m"; unset preexec_called; fi
}

zstyle ':completion:*' auto-description $'\e[38;5;247m=> %d\e[0m'
zstyle ':completion:*' completer _expand _complete _ignored _approximate _prefix
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' format $'\e[38;5;247m=> %d\e[0m'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' insert-unambiguous false
zstyle ':completion:*' list-prompt %SAt %l: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' max-errors 2
zstyle ':completion:*' menu select=1
zstyle ':completion:*' original true
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %l%s
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' verbose true

if [[ -e ~/.ssh/config ]]; then
    zstyle ':completion:*' hosts $(sed -ne 's/^Host //p' ~/.ssh/config)
    zstyle ':completion:*:ssh:*' users
fi

source ~/dotfiles/zshplugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/dotfiles/zshplugins/fzf-key-bindings.zsh
source ~/dotfiles/zshplugins/fzf-completion.zsh
source ~/.nix-profile/etc/profile.d/nix.sh 2>/dev/null

typeset -A ZSH_HIGHLIGHT_PATTERNS
ZSH_HIGHLIGHT_HIGHLIGHTERS+=(main pattern)
ZSH_HIGHLIGHT_PATTERNS+=('sudo' 'fg=yellow,bold')

bindkey "^T" transpose-chars
bindkey "^F" fzf-file-widget

export GPG_TTY=$(tty)

NPM_PACKAGES="${HOME}/.npm-packages"
export PATH="$PATH:$NPM_PACKAGES/bin"
export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"

test -e "$HOME/.iterm2_shell_integration.zsh" && source "$HOME/.iterm2_shell_integration.zsh"

if it2check 2>/dev/null; then
    _update_it2_touchbar() {
        it2setkeylabel push zsh_$$

        fnkeys=( "^[OP" "^[OQ" "^[OR" "^[OS"
                 "^[[15~" "^[[17~" "^[[18~" "^[[19~"
                 "^[[20~" "^[[21~" "^[[23~" "^[[24~"
                 "^[[1;2P" "^[[1;2Q" "^[[1;2R" "^[[1;2S"
                 "^[[15;2~" "^[[17;2~" "^[[18;2~" "^[[19;2~"
                 "^[[20;2~" "^[[21;2~" "^[[23;2~" "^[[24;2~" )

        IFS=$'\n' list=( / '..' $(ls -d */) ) 2>/dev/null
        for n in {1..24}; do
            if [[ "$list[$n]" = "/" ]]; then
                it2setkeylabel set "F$n" "直す"
                bindkey -s "$fnkeys[$n]" "^Q^[[A^M"
            elif [[ "$list[$n]" = "" ]]; then
                it2setkeylabel set "F$n" " "
                bindkey -r "$fnkeys[$n]"
            else
                it2setkeylabel set "F$n" "$list[$n]"
                bindkey -s "$fnkeys[$n]" "^Qcd '$list[$n]'^M"
            fi
        done
    }

    _restore_it2_touchbar() {
        it2setkeylabel pop zsh_$$
    }

    autoload add-zsh-hook
    add-zsh-hook precmd _update_it2_touchbar
    add-zsh-hook preexec _restore_it2_touchbar
fi
