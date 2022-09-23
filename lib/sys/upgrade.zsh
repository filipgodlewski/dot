#! /usr/bin/env zsh

function _dot::sys::upgrade::help {
  cat >&2 <<EOF
USAGE:
    ${(j: :)${(s.::.)0#_}% help} [options]

    Upgrade system-wide applications, packages, hosts and such.

OPTIONS:
    -a, --all                         Update everything: npm, brew and submodules, nvim venv, and hosts.
    -p, --packages                    Update npm, brew and submodules.
    -n, --nvim-venv                   Update nvim venv python packages.
    -h, --hosts                       Update hosts file with blockers for fakenews, gambling and porn sites.
    -h, --help                        Show this message.
EOF
  return 0
}
function _dot::sys::up {_dot::sys::upgrade "$@"}
function _dot::sys::upgrade {
  trap "unset help all packages nvim_venv hosts" EXIT ERR INT QUIT STOP CONT
  zparseopts -D -F -K -- \
    {h,-help}=help \
    {a,-all}=all \
    {p,-packages}=packages \
    {n,-nvim-venv}=nvim_venv \
    {H,-hosts}=hosts || return

  (($#help)) && {$0::help; return 0}

  (($#all || $#packages)) && {$0::_npm; $0::_brew; _dot::submodule::up}
  if [[ $+functions[_venv] ]]; then  # external dependency!
    (($#all || $#nvim_venv)) && {echo ":: Upgrade nvim venv ::"; venv update nvim}
    (($#all || $#hosts)) && $0::_hosts
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

  if [[ $(_dot::submodule::ls --target sys | grep $provider 2> /dev/null) ]]; then
    local repo_dir="$(echo ${$(git -C $DOTDIR submodule | grep $provider)##[[:blank:]]} | cut -d' ' -f2)"
    venv new --project-path $DOTDIR/$repo_dir --no-link 2> /dev/null
    venv run --name $provider -m pip install -r $DOTDIR/$repo_dir/requirements.txt
    venv run --name $provider $DOTDIR/$repo_dir/updateHostsFile.py -e fakenews gambling porn -f -r -a
    git -C $DOTDIR/$repo_dir reset --hard
  fi
}
