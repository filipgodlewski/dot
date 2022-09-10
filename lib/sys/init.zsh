#! /usr/bin/env zsh

function _dot::sys::help {
    cat >&2 <<EOF
Usage: ${(j: :)${(s.::.)0#_}% help} <command...> [options]

Available commands:

    upgrade <command>      Manage dotfile submodules. (alias: up)
EOF
    return 0
}
function _dot::sys {
    (($# > 0 && $+functions[$0::$1])) || { $0::help; return 1 }
    local cmd="$1"; shift
    $0::$cmd "$@"
}

