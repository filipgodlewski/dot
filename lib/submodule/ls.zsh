#! /usr/bin/env zsh

function _dot::submodule::ls::help {
  cat >&2 <<EOF
USAGE:
    ${(j: :)${(s.::.)0#_}% help} [options]

    List all submodules.

OPTIONS:
    -k, --target <name>                  Select submodule folder. Optional.
    -h, --help                        Show this message.
EOF
  return 0
}
function _dot::submodule::ls {
  trap "unset help target" EXIT ERR INT QUIT STOP CONT
  zparseopts -D -F -K -- {h,-help}=help {t,-target}:=target

  (($#help)) && { $0::help; return 0 }

  # requires git 2.7.0
  (( $#target )) && local chosen_target=$target || local chosen_target=$(jq -r '.submodules | keys[]' $DOTDIR_CONFIG | fzf)
  (( $#chosen_target )) || { echo "No target selected."; return 1; }
  local subfolder=$(jq -r ".submodules.$chosen_target" $DOTDIR_CONFIG)

  local urls=(${(@f)$(cat $DOTDIR/.gitmodules | grep 'url =' | awk '{print $3}')})
  local submodules=(${(@f)$(cat $DOTDIR/.gitmodules | grep 'path =' | awk '{print $3}')})
  local parent=$chosen_target/.local/share/$subfolder/

  local -a data
  for i in {1..$#urls}; do
    data+=("$(awk -v p=$parent '{sub(p, ""); print}' <<< $submodules[$i]) -> $urls[$i]")
  done
  echo ${(F)data} | grep -v '.local' | sort
}
