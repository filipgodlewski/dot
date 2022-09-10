#! /usr/bin/env zsh

function _dot::sys::help {
    cat >&2 <<EOF
Usage: ${(j: :)${(s.::.)0#_}% help} <command...> [options]

Available commands:

    update <command>       Manage dotfile submodules. (alias: up)
EOF
    return 0
}
function _dot::sys {
    (($# > 0 && $+functions[_$0::$1])) || { _$0::help; return 1 }
    local cmd="$1"; shift
    _dot::$cmd "$@"
}

