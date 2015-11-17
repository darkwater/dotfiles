#!/bin/bash

DIR="$(dirname $0)"

echo "Note: You should run this script from your target installation"
echo "  directory into the relative path of the dotfiles."
echo
echo "(I wouldn't recommend running this script with an absolute path,"
echo "  like ~/dotfiles/setup-symlinks.sh - relative paths are cool.)"
echo
echo -e "Running from: \e[1m$(pwd)\e[0m"
echo -e "Linking to:   \e[1m$DIR\e[0m"
echo
echo -e "Recommended:  \e[1m$HOME\e[0m"
echo -e "              \e[1mdotfiles\e[0m"
echo
echo "Symlinks will look like:"
echo "$(pwd)/.config/bspwm -> ../$DIR/.config/bspwm"
echo "$(pwd)/.gitconfig    -> $DIR/.gitconfig"
echo "$(pwd)/.zshrc        -> $DIR/.zshrc"

if [[ "$DIR" = "." ]]
then
    echo -e "\n\e[1;31mYou're running this script from its own directory!"
    echo -e "This is probably not what you want! Read above.\e[0m"
fi

echo
echo "Hit enter to continue, or ^C to abort..."

read

mkdir -p .config
for conf in "$DIR/.config/"*
do
    file="$(basename $conf)"
    echo ".config/$file -> ../$DIR/.config/$file"
    ln -s "../$DIR/.config/$file" ".config/"
done 2>/tmp/.dark-dotfiles-setup-script.log

for file in .conkyrc .gitconfig .githelpers .Xresources .zshrc
do
    echo "$file -> $DIR/$file"
    ln -s "$DIR/$file" .
done 2>>/tmp/.dark-dotfiles-setup-script.log

echo
cat /tmp/.dark-dotfiles-setup-script.log
echo

echo "Done! Don't forget:"
echo " - Configure your ~/.gitconfig"
echo " - cd $DIR && git submodule init && git submodule update"
echo " - You're using neovim now - you can throw vim away"
