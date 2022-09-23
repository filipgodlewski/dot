#! /usr/bin/env zsh

function _dot::submodule::rm::help {
  cat >&2 <<EOF
USAGE:
    ${(j: :)${(s.::.)0#_}% help} [options] [NAME]...

    Remove submodule(s).

ARGS:
    <NAME>...    Name of the submodule(s) you are willing to remove from dotfiles.

OPTIONS:
    -t, --target                         Select submodule folder. Optional.
    -h, --help                        Show this message.
EOF
  return 0
}
function _dot::submodule::rm {
  trap "unset help target" EXIT ERR INT QUIT STOP CONT
  zparseopts -D -E -K -- {h,-help}=help {t,-target}:=target

  ((${#@} > 0)) || {$0::help; return 1}

  # requires git 2.7.0
  (($#target)) && local chosen_target=$(jq -r '.submodules | keys[]' $DOTDIR_CONFIG | fzf) || local chosen_target=$target[-1]
  [[ -z $chosen_target ]] && {echo "No target selected."; return 1}
  local folder=$(jq -r ".submodules.$chosen_target" $DOTDIR_CONFIG)
  local target="$chosen_target/.local/share/$folder"

  if [[ "${#@}" -eq 0 ]]; then
    local find_sm=$(\
      git -C $DOTDIR submodule--helper list \
      | grep "$target" \
      | awk -v t=$target '{sub(t"/", ""); print $4}' \
      | fzf -m --preview-window=right:80% --preview "bat --color=always --line-range :500 $DOTDIR/$target/{}/README.*" \
    )
    local chosen_sm=("${(@f)find_sm}")
    [[ -z $chosen_sm ]] && {echo "No submodule selected."; return 1}
  else
    local chosen_sm=("$@")
  fi

  echo "Selected submodule(s):\n"
  echo "${(F)chosen_sm}\n"
  echo "---\n"

  for sm in ${chosen_sm[@]}; do
    local full_path=$target/$sm
    [[ -d $DOTDIR/$full_path ]] || {echo "Directory '$DOTDIR/$full_path' does not exist."; continue}
    echo "Taking $sm..."
    git -C $DOTDIR submodule deinit --quiet -f $full_path
    echo "Deinitialized submodule."

    git -C $DOTDIR rm --quiet -f $full_path
    rm -rf $DOTDIR/.git/modules/$full_path
    echo "Removed submodule from tree.\n"
  done
}
