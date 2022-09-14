#! /usr/bin/env zsh

[[ -z "$DOT_PLUG" ]] && export DOT_PLUG="${${(%):-%x}:a:h}"
[[ -z "$DOTDIR" ]] && export DOTDIR="$HOME/dotfiles"
[[ -z "$DOTDIR_CONFIG" ]] && export DOTDIR_CONFIG="$DOTDIR/config.json"

for config_file ("$DOT_PLUG"/lib/**/*.zsh); do
  source "$config_file"
done
unset config_file
