#! /usr/local/bin/zsh

function _dot::submodule::ls {
    zparseopts -D -E -A opts -key:

    # requires git 2.7.0
    [[ "$opts[--key]" == "" ]] && local chosen_key=$(jq -r '.submodules | keys[]' $DOTDIR_CONFIG | fzf) || local chosen_key=$opts[--key]
    [[ $#chosen_key -eq 0 ]] && { echo "No key selected."; return 1; }
    local subfolder=$(jq -r ".submodules.$chosen_key" $DOTDIR_CONFIG)

    local urls=(${(@f)$(cat $DOTDIR/.gitmodules | grep 'url =' | awk '{print $3}')})
    local submodules=(${(@f)$(cat $DOTDIR/.gitmodules | grep 'path =' | awk '{print $3}')})
    local parent=$chosen_key/.local/share/$subfolder/

    local -a data
    for i in {1..$#urls}; do
      data+=("$(awk -v p=$parent '{sub(p, ""); print}' <<< $submodules[$i]) -> $urls[$i]")
    done
    echo ${(F)data[@]} | grep -v '.local' | sort
}
