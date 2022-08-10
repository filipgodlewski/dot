#! /usr/local/bin/zsh

function _dot::help {
    cat >&2 <<EOF
Usage: ${(j: :)${(s.::.)0#_}} <command...> [options]

Available commands:

    submodule <command>    Manage dotfile submodules. (alias: sm)
EOF
    return 0
}
function dot {
    (($# > 0 && $+functions[_$0::$1])) || { _$0::help; return 1 }
    local cmd="$1"; shift
    _dot::$cmd "$@"
}
