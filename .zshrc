setopt auto_cd
setopt append_history
setopt inc_append_history
setopt extended_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt nomatch
setopt notify
setopt prompt_subst
unsetopt beep

export PATH="$HOME/dotfiles/bin:$HOME/.cargo/bin:$HOME/.local/bin:$PATH"

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

alias f="fvm flutter"
alias fr="fvm flutter run"
alias fp="fvm flutter pub"
alias fbb="fvm dart run build_runner build"
alias fbw="fvm dart run build_runner watch"

alias c="cargo"
alias g="git"
alias h="hyprctl"
alias s="ssh"
alias x="cargo xtask"

alias sysa="sysz -s active"
alias scu="systemctl --user"
alias ssc="sudo systemctl"
alias svim="sudo nvim"
alias sd="sudo docker"

alias sps="sudo pacman -S"
alias spsyu="sudo pacman -Syu"
alias spr="sudo pacman -Rs"
alias pss="pacman -Ss"
alias psi="pacman -Si"
alias pql="pacman -Ql"
alias pqo="pacman -Ql"

alias ys="yay -S"
alias ysyu="yay -Syu"
alias yss="yay -Ss"
alias ysi="yay -Si"
alias yql="yay -Ql"
alias yqo="yay -Ql"

alias sai="sudo apt install"
alias apts="apt search"

alias ip="ip --color=auto"
alias fd="fd --glob"

ssh() {
    # interferes with `ssh host foo > bar`
    # set_window_title "ssh $*"
    command ssh "$@"
}

exists() { command -v $1 >/dev/null }
exists eza && alias ls=eza

l() {
    # -aa only in $HOME and without arguments
    aa="$([[ "$(pwd)" = "$HOME" && "$#" = 0 ]] || echo -n -aa)"
    ls -lgF $aa --group-directories-first "$@"
}

alias lr="ls -lgaaF -snew"
alias lt="ls -lgF --tree --level=3"

sl() {
    # ls -aa only in $HOME and without arguments
    aa="$([[ "$(pwd)" = "$HOME" && "$#" = 0 ]] || echo -n -aa)"
    if exists eza; then
        sudo eza -lgF $aa --group-directories-first "$@"
    else
        sudo ls -lgF $aa --group-directories-first "$@"
    fi
}

downloads() {
    cd ~/?ownloads/
    eza -alF -snew --color=always | tail
}

man() {
    nvim +"Man $*" +only
}

autoload -Uz compinit promptinit colors

if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+2) ]]; then
    compinit
else
    compinit -C
fi

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
    case "$(hostname | cut -d. -f1)" in
        tetsuya) echo -n "\e[1;38;2;159;204;225;48;2;27;27;38m"   ;;
        nagumo)  echo -n "\e[1;38;2;206;16;21;48;2;36;28;22m"     ;;
        fubuki)  echo -n "\e[1;38;2;250;250;250;48;2;81;114;142m" ;;
        sinon)   echo -n "\e[1;38;2;196;252;227;48;2;48;42;3m"    ;;
        atsushi) echo -n "\e[1;38;2;189;155;235;48;2;50;50;50m"   ;;
        winbox)  echo -n "\e[1;38;2;159;204;225;48;2;27;27;88m"   ;;
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
    set_window_title "%m: %~"
    echo -n "%}"

    echo
    [[ -n "$ZSH_PROMPT_AUR_PKG" ]] && echo -n "%{\e[33;1m%}[$ZSH_PROMPT_AUR_PKG] "
    echo -n "%{\e]133;A\a$(hostname_color)%} %m $reset"

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
    set_window_title "$(hostname -s) $ $cmd"
}
precmd() {
    local exit_status="$?"
    if [ "$exit_status" != 0 ] && [ "$preexec_called" = 1 ]
    then echo "\e[1;31mexit $exit_status\e[0m"; unset preexec_called; fi

    tput cvvis
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

if [[ "$TERM" == "xterm-kitty" ]]; then
    export TERM="xterm-256color"
fi

source /usr/share/doc/find-the-command/ftc.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
source ~/.nix-profile/etc/profile.d/nix.sh 2>/dev/null
source ~/.dart-cli-completion/fvm.zsh 2>/dev/null

typeset -A ZSH_HIGHLIGHT_PATTERNS
ZSH_HIGHLIGHT_HIGHLIGHTERS+=(main pattern)
ZSH_HIGHLIGHT_PATTERNS+=('sudo' 'fg=yellow,bold')

bindkey "^T" transpose-chars
bindkey "^F" fzf-file-widget

export GPG_TTY=$(tty)

NPM_PACKAGES="${HOME}/.npm-packages"
export PATH="$PATH:$NPM_PACKAGES/bin"
export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"

unsetopt extendedglob

if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
