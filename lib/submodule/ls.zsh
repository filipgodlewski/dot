#! /usr/bin/env zsh

function _dot::submodule::ls::help {
  cat >&2 <<EOF
USAGE:
    ${(j: :)${(s.::.)0#_}% help} [options]

    List all submodules.

OPTIONS:
    -k, --key                         Select submodule folder. Optional.
    -h, --help                        Show this message.
EOF
  return 0
}
function _dot::submodule::ls {
  trap "unset help key" EXIT ERR INT QUIT STOP CONT
  zparseopts -D -E -K -- {h,-help}=help {k,-key}:=key

  ((${#@} > 0)) || { $0::help; return 1 }

  # requires git 2.7.0
  (( $#key )) && local chosen_key=$(jq -r '.submodules | keys[]' $DOTDIR_CONFIG | fzf) || local chosen_key=$key[-1]
  [[ $#chosen_key -eq 0 ]] && { echo "No key selected."; return 1; }
  local subfolder=$(jq -r ".submodules.$chosen_key" $DOTDIR_CONFIG)

  local urls=(${(@f)$(cat $DOTDIR/.gitmodules | grep 'url =' | awk '{print $3}')})
  local submodules=(${(@f)$(cat $DOTDIR/.gitmodules | grep 'path =' | awk '{print $3}')})
  local parent=$chosen_key/.local/share/$subfolder/

  local -a data
  for i in {1..$#urls}; do
    data+=("$(awk -v p=$parent '{sub(p, ""); print}' <<< $submodules[$i]) -> $urls[$i]")
  done
  echo ${(F)data} | grep -v '.local' | sort
}
