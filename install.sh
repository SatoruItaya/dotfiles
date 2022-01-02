#!/bin/bash -e

IGNORE_PATTERN="^\.(git)$"

for dotfile in .??*; do
    [[ $dotfile =~ $IGNORE_PATTERN ]] && continue
        case "$dotfile" in
            ".gitignore" ) cp "$(pwd)/$dotfile" "$HOME/.config/git/ignore" ;;
            * ) ln -snfv "$(pwd)/$dotfile" "$HOME/$dotfile" ;;
        esac
done
