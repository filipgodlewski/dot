#! /usr/bin/env zsh

function _dot::submodule::help {
    cat >&2 <<EOF
Usage: ${(j: :)${(s.::.)0#_}% help} <command> [options]

Available commands:

    add <URL>      Add new submodule to the dotfiles repository.
                        Will prompt to select target folder.
    ls             List all added submodules within the dotfiles repository.
    rm             Remove selected submodule from dotfiles repository.
    up             Update all submodules recursively. 
EOF
    return 0
}
function _dot::sm { _dot::submodule "$@" }
function _dot::submodule {
    (($# > 0 && $+functions[$0::$1])) || { $0::help; return 1 }
    local cmd="$1"; shift
    $0::$cmd "$@"
}
