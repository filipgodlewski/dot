#! /usr/bin/env zsh

function _dot::submodule::up {
    git -C $DOTDIR submodule update --init --remote --recursive
}
