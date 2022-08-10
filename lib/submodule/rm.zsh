#! /usr/local/bin/zsh

function _dot::submodule::rm {
    # requires git 2.7.0
    local key=$(jq -r '.submodules | keys[]' $DOTDIR_CONFIG | fzf)
    local folder=$(jq -r ".submodules.$key" $DOTDIR_CONFIG)
    local target="$key/.local/share/$folder"
    local chosen_sm=$(\
      git -C $DOTDIR submodule--helper list \
      | grep "$target" \
      | awk -v t=$target '{sub(t"/", ""); print $4}' \
      | fzf --preview-window=right:80% --preview "bat --color=always --line-range :500 $DOTDIR/$target/{}/README.*" \
    )

    git -C $DOTDIR submodule deinit $folder/$chosen_sm
    git -C $DOTDIR rm $folder/$chosen_sm
}
