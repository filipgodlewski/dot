#! /usr/bin/env zsh

function _dot::submodule::add::help {
  cat >&2 <<EOF
USAGE:
    ${(j: :)${(s.::.)0#_}% help} [options] [URL]

    Add new submodule to dotfiles.

ARGS:
    <URL>        URL address to the .git object.

OPTIONS:
    -t, --target                      Select submodule folder. Optional.
    -h, --help                        Show this message.
EOF
  return 0
}
function _dot::submodule::add {
  trap "unset help target" EXIT ERR INT QUIT STOP CONT
  zparseopts -D -E -K -- {h,-help}=help {t,-target}:=target

  (($#)) || {$0::help; return 1}

  local urls=("$@")
  (($#target)) && local chosen_target=$target[-1] || local chosen_target=$(jq -r '.submodules | keys[]' $DOTDIR_CONFIG | fzf)
  (($#chosen_target)) || {echo "No target selected."; return 1}
  local folder=$(jq -r ".submodules.$chosen_target" $DOTDIR_CONFIG)
  local target="$chosen_target/.local/share/$folder"

  for url in ${urls[@]}; do
    local author=$(echo $url | cut -d'/' -f4)
    local repo="${$(echo $url | cut -d'/' -f5)[1,-5]}"
    git -C $DOTDIR submodule add -f $url $target/$author.$repo
    git -C $DOTDIR submodule update --init --recursive $target/$author.$repo
  done
}
