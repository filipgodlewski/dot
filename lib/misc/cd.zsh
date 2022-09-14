#! /usr/bin/env zsh

function _dot::sys::help {
  cat >&2 <<EOF
USAGE:
    ${(j: :)${(s.::.)0#_}% help} <SUBCOMMAND>

    Change directory to dotfiles dir.

OPTIONS:
    -h, --help                        Show this message.
EOF
  return 0
}
function _dot::cd {
  trap "unset help" EXIT ERR INT QUIT STOP CONT
  zparseopts -D -E -K -- {h,-help}=help || return

  (( $#help )) && {$0::help; return 0}
  cd $DOTDIR
}
