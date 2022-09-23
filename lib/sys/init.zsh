#! /usr/bin/env zsh

function _dot::sys::help {
  cat >&2 <<EOF
USAGE:
    ${(j: :)${(s.::.)0#_}% help} <SUBCOMMAND>

OPTIONS:
    -h, --help                        Show this message.

SUBCOMMANDS:
    upgrade                           Upgrade system-wide packages and such. (alias: up)
EOF
  return 0
}
function _dot::sys {
  trap "unset help" EXIT ERR INT QUIT STOP CONT
  zparseopts -D -E -K -- {h,-help}=help

  (($# == 0 && $#help)) && {$0::help; return 0}
  (($# > 0 && $+functions[$0::$1])) || {$0::help; return 1}

  local cmd="$1"; shift
  $0::$cmd "$@"
}
