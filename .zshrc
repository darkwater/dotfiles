# zsh settings
setopt appendhistory autocd notify hist_ignore_all_dups hist_ignore_space prompt_subst promptsubst promptpercent
unsetopt extendedglob nomatch beep

HISTFILE=~/.zhistory
HISTSIZE=10000
SAVEHIST=100000

# completion settings
zstyle :compinstall filename ~/.zshrc
zstyle ':completion:*' matcher-list 'm:{A-ZÄÖÜÉÈËa-zäöüéèë}={a-zäöüéèëA-ZÄÖÜÉÈË}' '+l:|=*'
zstyle ':completion::complete:*' use-cache 1

autoload -Uz compinit promptinit colors
compinit
promptinit
colors

# key settings
bindkey -e
stty stop '' -ixon -ixoff # disable ^S and ^Q
bindkey '^[[1;5D' emacs-backward-word
bindkey '^[[1;5C' emacs-forward-word
bindkey '^[[H'    beginning-of-line
bindkey '^[[4~'   end-of-line
bindkey '^[[P'    delete-char

# environment settings
export PATH="$HOME/.cargo/bin:$HOME/bin:$HOME/dotfiles/bin:$PATH:/usr/sbin:/sbin"
export EDITOR="/usr/bin/nvim"

# cope if installed
if command -v cope_path > /dev/null; then
    export PATH="$(cope_path):$PATH"
fi

# program settings
export GREP_COLORS='sl=:cx=38;5;242:rv:mt=38;5;214'
export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;40:st=37;44:ex=01;32:'


function ll() {
    if test \( "$PWD" = "$HOME" -a $# = 0 \) -o "$1" = ~; then
        ls -hlF --color=auto --group-directories-first "$@"
        return
    fi

    ls -halF --color=auto --group-directories-first "$@"
}

function downloads() {
    cd ~/downloads/
    ls -hAlt --color=always | head -n 11 | tail | tac
}

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
    clear # to show dat nice background color
fi


# prompt
local separator="%{$reset_color$fg_bold[black]%}/%{$reset_color%}"

local return_code="%(?..%{$fg[red]%}-> %?\n)"

local time="%{$fg[yellow]%}%T"
local user_host="%{$fg[green]%}%n@%m"
local current_dir="%{$fg[blue]%}%~"

local prompt_indicator="%{$fg_bold[yellow]%}>"

PROMPT='$(zsh_prompt)'

function set_window_title() {
    echo -n "\e]0;$*\a"
}

function git_info() {
    local ref=$(git symbolic-ref HEAD 2> /dev/null)
    local attached=true
    if [[ -z "$ref" ]]; then
        ref=$(git rev-parse --short HEAD 2> /dev/null)
        attached=false
    fi

    if [[ -n "$ref" ]]; then

        echo -n "$separator "

        if [[ "$attached" = false ]]; then
            echo -n "%{$fg_bold[red]%}"
        elif [[ "$(git status --porcelain)" != "" ]]; then
            echo -n "%{$fg_bold[yellow]%}"
        else
            echo -n "%{$fg_bold[green]%}"
        fi

        # repository name @ branch
        echo -n "${ref#refs/heads/}"
        # echo -n "[${ref#refs/heads/}] $(basename "$(git rev-parse --show-toplevel)")"

        # internal path (relative to repository root)
        # echo -n "%{$fg[blue]%}/$(git rev-parse --show-prefix)"

    fi
}

function zsh_prompt() {
    echo
    echo -n "$return_code"
    echo    " $time $separator $user_host $separator $current_dir $(git_info)"
    echo -n "$prompt_indicator "

    # color reset
    echo -n "%{$reset_color%}"

    # bell and window title set
    echo -n "%{\a"
    set_window_title "${USER}@$(hostname): ${PWD}"
    echo -n "%}"
}

function preexec() {
    cmd="$(echo "$2" | tr -d '\000-\037')"
    set_window_title "${USER}@$(hostname): ${PWD} $ $cmd"
}


source ~/dotfiles/zshplugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
