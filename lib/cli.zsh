#! /usr/bin/env zsh

function _dot::help {
  cat >&2 <<EOF
dot -- A very simple dotfiles manager.

USAGE:
    ${(j: :)${(s.::.)0#_}% help} <SUBCOMMAND>

OPTIONS:
    -h, --help                        Show this message.

SUBCOMMANDS:
    cd                                Go to dotfiles dir.
    submodule <SUBCOMMAND>            Manage dotfile submodules. (alias: sm)
    sys <SUBCOMMAND>                  Manage system.
EOF
  return 0
}
function dot {
  trap "unset help" EXIT ERR INT QUIT STOP CONT
  zparseopts -D -E -K -- {h,-help}=help || return

  (( ${#@} == 0 && $#help )) && {_$0::help; return 0}
  (($# > 0 && $+functions[_$0::$1])) || { _$0::help; return 1 }

  local cmd="$1"; shift
  (( $#help )) && _dot::$cmd "$@" --help || _dot::$cmd "$@"
}
