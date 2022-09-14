#! /usr/bin/env zsh

function _dot::submodule::add::help {
  cat >&2 <<EOF
USAGE:
    ${(j: :)${(s.::.)0#_}% help} [options] [URL]

    Add new submodule to dotfiles.

ARGS:
    <URL>        URL address to the .git object.

OPTIONS:
    -k, --key                         Select submodule folder. Optional.
    -h, --help                        Show this message.
EOF
  return 0
}
function _dot::submodule::add {
  trap "unset help key" EXIT ERR INT QUIT STOP CONT
  zparseopts -D -E -K -- {h,-help}=help {k,-key}:=key

  ((${#@} > 0)) || { $0::help; return 1 }

  local urls=("$@")
  (( $#key )) && local chosen_key=$(jq -r '.submodules | keys[]' $DOTDIR_CONFIG | fzf) || local chosen_key=$key[-1]
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
