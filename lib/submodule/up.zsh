#! /usr/bin/env zsh

function _dot::submodule::up::help {
  cat >&2 <<EOF
USAGE:
    ${(j: :)${(s.::.)0#_}% help}

    Upgrade submodules.

OPTIONS:
    -h, --help                        Show this message.
EOF
  return 0
}
function _dot::submodule::up {
  trap "unset help" EXIT ERR INT QUIT STOP CONT
  zparseopts -D -E -K -- {h,-help}=help || return

  (( $#help )) && {_$0::help; return 0}
  git -C $DOTDIR submodule update --init --remote --recursive

  # rebuild nvim remote plugins
  cd $XDG_DATA_HOME/nvim/site/pack/add/start/nvim-telescope.telescope-fzf-native.nvim
  make &> /dev/null
  cd - &> /dev/null
  nvim --headless +"UpdateRemotePlugins | q" &> /dev/null
}
