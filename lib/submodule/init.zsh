#! /usr/bin/env zsh

function _dot::submodule::help {
    cat >&2 <<EOF
USAGE:
    ${(j: :)${(s.::.)0#_}% help} <SUBCOMMAND>

OPTIONS:
    -h, --help                        Show this message.

SUBCOMMANDS:
    add <URL>                         Add new submodule to the dotfiles repository.
                                      Will prompt to select target folder.
    ls                                List all added submodules within the dotfiles repository.
    rm                                Remove selected submodule from dotfiles repository.
    up                                Update all submodules recursively. 
EOF
    return 0
}
function _dot::sm { _dot::submodule "$@" }
function _dot::submodule {
  trap "unset help" EXIT ERR INT QUIT STOP CONT
  zparseopts -D -E -K -- {h,-help}=help

  (($# == 0 && $#help)) && {$0::help; return 0}
  (($# > 0 && $+functions[$0::$1])) || {$0::help; return 1}

  local cmd="$1"; shift
  $0::$cmd "$@"
}
