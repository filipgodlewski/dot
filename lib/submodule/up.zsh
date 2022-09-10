#! /usr/bin/env zsh

function _dot::submodule::up {
    git -C $DOTDIR submodule update --init --remote --recursive

    # rebuild nvim remote plugins
    cd $XDG_DATA_HOME/nvim/site/pack/add/start/nvim-telescope.telescope-fzf-native.nvim
    make &> /dev/null
    cd - &> /dev/null
    nvim --headless +"UpdateRemotePlugins | q" &> /dev/null
}
