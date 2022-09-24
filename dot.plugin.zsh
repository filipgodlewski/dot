#! /usr/bin/env zsh

0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

typeset -g DOT_BASE_DIR="${0:h}"
typeset -g DOTFILES_DATA_HOME=${DOTFILES_DATA_HOME:-$HOME/dotfiles}
typeset -g DOTFILES_CONFIG_FILE=${DOTFILES_CONFIG_FILE:-$DOTFILES_DATA_HOME/config.json}

if [[ ${zsh_loaded_plugins[-1]} != */dot && -z ${fpath[(r)${0:h}]} ]]; then
  fpath+=("${0:h}")
fi
autoload dot
