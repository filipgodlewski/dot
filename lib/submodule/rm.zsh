#! /usr/bin/env zsh

function _dot::submodule::rm {
    zparseopts -D -E -A opts -key:

    # requires git 2.7.0
    [[ "$opts[--key]" == "" ]] && local chosen_key=$(jq -r '.submodules | keys[]' $DOTDIR_CONFIG | fzf) || local chosen_key=$opts[--key]
    [[ -z $chosen_key ]] && { echo "No key selected."; return 1; }
    local folder=$(jq -r ".submodules.$chosen_key" $DOTDIR_CONFIG)
    local target="$chosen_key/.local/share/$folder"

    if [[ "${#@}" -eq 0 ]]; then
        local find_sm=$(\
          git -C $DOTDIR submodule--helper list \
          | grep "$target" \
          | awk -v t=$target '{sub(t"/", ""); print $4}' \
          | fzf -m --preview-window=right:80% --preview "bat --color=always --line-range :500 $DOTDIR/$target/{}/README.*" \
        )
        local chosen_sm=("${(@f)find_sm}")
        [[ -z $chosen_sm ]] && { echo "No submodule selected."; return 1; }
    else
        local chosen_sm=("$@")
    fi

    echo "Selected submodule(s):\n"
    echo "${(F)chosen_sm}\n"
    echo "---\n"

    for sm in ${chosen_sm[@]}; do
        local full_path=$target/$sm
        [[ -d $DOTDIR/$full_path ]] || { echo "Directory '$DOTDIR/$full_path' does not exist."; continue; }
        echo "Taking $sm..."
        git -C $DOTDIR submodule deinit --quiet -f $full_path
        echo "Deinitialized submodule."

        git -C $DOTDIR rm --quiet -f $full_path
        rm -rf $DOTDIR/.git/modules/$full_path
        echo "Removed submodule from tree.\n"
    done
}
