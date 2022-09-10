#! /usr/bin/env zsh

function _dot::sys::up { _dot::sys::upgrade "$@" }
function _dot::sys::upgrade {
  $0::_npm
  $0::_brew
  _dot::submodule::up
  [[ $+functions[_venv::update] ]] && venv update nvim  # external dependency!
}

function _dot::sys::upgrade::_npm {
  npm install --global npm
  local outdated_packages=(${(f@)$(npm list -g --depth 0)##*/})
  for package in $outdated_packages; do
    npm update -g $package
  done
  npm cache clean --force
}

function _dot::sys::upgrade::_brew {
  brew update
  brew bundle --file=~/.Brewfile
  brew cleanup --prune=all
}
