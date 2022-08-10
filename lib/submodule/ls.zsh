#! /usr/local/bin/zsh

function _dot::submodule::ls {
    # requires git 2.7.0
    local key=$(jq -r '.submodules | keys[]' $DOTDIR_CONFIG | fzf)
    local subfolder=$(jq -r ".submodules.$key" $DOTDIR_CONFIG)

    local urls=(${(@f)$(cat $DOTDIR/.gitmodules | grep 'url =' | awk '{print $3}')})
    local submodules=(${(@f)$(cat $DOTDIR/.gitmodules | grep 'path =' | awk '{print $3}')})
    local parent="$key/.local/share/$subfolder/"

    local -a data
    for i in {1..$#urls}; do
      data+=("$(awk -v p=$parent '{sub(p, ""); print}' <<< $submodules[$i]) -> $urls[$i]")
    done
    echo ${(F)data[@]} | grep -v '.local' | sort
}
