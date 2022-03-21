#!/bin/bash

set -e

is_linked() {
    path="$(readlink "$1")"
    echo "$path" | grep -q "dotfiles"
}

check() {
    if is_linked "$1"; then
        echo -e "\e[32;1m✔ \e[0;32m$1\e[0m"
    else
        echo -e "\e[31;1m✗ \e[0;31m$1\e[0m"
    fi
}

check ~/.config/dunst
check ~/.config/nvim
check ~/.gitconfig
check ~/.Xresources
check ~/.zshrc
