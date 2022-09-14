#! /usr/bin/env zsh

function _dot::sys::up { _dot::sys::upgrade "$@" }
function _dot::sys::upgrade {
  zparseopts -D -F -A opts -all -npm -brew -submodules -nvim -hosts

  (($#opts[--all] || $#opts[--npm])) && $0::_npm
  (($#opts[--all] || $#opts[--brew])) && $0::_brew
  (($#opts[--all] || $#opts[--submodules])) && _dot::submodule::up
  if [[ $+functions[_venv] ]]; then  # external dependency!
    (($#opts[--all] || $#opts[--nvim])) && {echo ":: Upgrade nvim venv ::"; venv update nvim}
    (($#opts[--all] || $#opts[--hosts])) && $0::_hosts
  fi
}

function _dot::sys::upgrade::_npm {
  echo ":: Upgrade npm ::"
  npm install --global npm
  local outdated_packages=(${(f@)$(npm list -g --depth 0 -p)##*/})
  for package in $outdated_packages; do
    npm update -g $package
  done
  npm cache clean --force
}

function _dot::sys::upgrade::_brew {
  echo ":: Upgrade brew ::"
  brew update
  brew bundle dump --force --file=~/.Brewfile
  brew bundle --file=~/.Brewfile
  brew cleanup --prune=all
}

function _dot::sys::upgrade::_hosts {
  echo ":: Upgrade hosts ::"
  local provider=$(jq -e -r '."hosts provider"' $DOTDIR_CONFIG 2> /dev/null)
  (($? == 1)) && {echo "No 'hosts provider' set in $DOTDIR_CONFIG! Can't perform setting up hosts."; return 0}

  if [[ $(_dot::submodule::ls --key sys | grep $provider 2> /dev/null) ]]; then
    local repo_dir="$(echo ${$(git -C $DOTDIR submodule | grep $provider)##[[:blank:]]} | cut -d' ' -f2)"
    venv new --project-path $DOTDIR/$repo_dir --no-link 2> /dev/null
    venv run --name $provider -m pip install -r $DOTDIR/$repo_dir/requirements.txt
    venv run --name $provider $DOTDIR/$repo_dir/updateHostsFile.py -e fakenews gambling porn -f -r -a
  fi
}
