#! /usr/local/bin/zsh

function _dot::submodule::add::help {
    cat >&2 <<EOF
Usage: ${(j: :)${(s.::.)0#_}} <URL>
EOF
    return 0
}
function _dot::submodule::add {
    (($# > 0)) || { $0::help; return 1 }
    local url="$1"; shift
    local key=$(jq -r '.submodules | keys[]' $DOTDIR_CONFIG | fzf)
    local folder=$(jq -r ".submodules.$key" $DOTDIR_CONFIG)
    local author=$(echo $url | cut -d'/' -f4)
    local repo=$(echo $url | cut -d'/' -f5)
    local target="$key/.local/share/$folder/$author/${repo[1,-5]}"

    git -C $DOTDIR submodule add -f $url $target
    git -C $DOTDIR submodule update --init --recursive $target
}