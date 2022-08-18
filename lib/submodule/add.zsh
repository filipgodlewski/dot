#! /usr/bin/env zsh

function _dot::submodule::add::help {
    cat >&2 <<EOF
Usage: ${(j: :)${(s.::.)0#_}% help} [-n, --key=KEY] <URL>
EOF
    return 0
}
function _dot::submodule::add {
    zparseopts -D -E -A opts -key:

    ((${#@} > 0)) || { $0::help; return 1 }

    local urls=("$@")
    [[ "$opts[--key]" == "" ]] && local chosen_key=$(jq -r '.submodules | keys[]' $DOTDIR_CONFIG | fzf) || local chosen_key=$opts[--key]
    [[ $#chosen_key -eq 0 ]] && { echo "No key selected."; return 1; }
    local folder=$(jq -r ".submodules.$chosen_key" $DOTDIR_CONFIG)
    local target="$chosen_key/.local/share/$folder"

    for url in ${urls[@]}; do
        local author=$(echo $url | cut -d'/' -f4)
        local repo="${$(echo $url | cut -d'/' -f5)[1,-5]}"
        git -C $DOTDIR submodule add -f $url $target/$author.$repo
        git -C $DOTDIR submodule update --init --recursive $target/$author.$repo
    done
}
