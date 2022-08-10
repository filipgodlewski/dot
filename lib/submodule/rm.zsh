#! /usr/local/bin/zsh

function _dot::submodule::rm {
    # requires git 2.7.0
    local chosen_key=$(jq -r '.submodules | keys[]' $DOTDIR_CONFIG | fzf)
    [[ $#chosen_key -eq 0 ]] && { echo "No key selected."; return 1; }
    local folder=$(jq -r ".submodules.$chosen_key" $DOTDIR_CONFIG)
    local target="$chosen_key/.local/share/$folder"
    local chosen_sm=$(\
      git -C $DOTDIR submodule--helper list \
      | grep "$target" \
      | awk -v t=$target '{sub(t"/", ""); print $4}' \
      | fzf --preview-window=right:80% --preview "bat --color=always --line-range :500 $DOTDIR/$target/{}/README.*" \
      || return 2
    )
    [[ $#chosen_sm -eq 0 ]] && { echo "No submodule selected."; return 1; }
    echo "Selected submodule: $chosen_sm\n"

    git -C $DOTDIR submodule deinit -f $target/$chosen_sm
    echo "Deinitialized submodule.\n"

    git -C $DOTDIR rm -f $target/$chosen_sm
    rm -rf $DOTDIR/.git/modules/$target/$chosen_sm
    echo "Removed submodule from tree.\n"
}
