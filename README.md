# DOT

_My personal Zsh-compatible dotfiles manager_

## 📖 Installation

Clone to the repository and source in rc file.

### 📦 Dependencies

- zsh  (`brew install zsh`)
- jq  (`brew install jq`)
- fzf  (`brew install fzf`)
- git >= 2.7.0  (is installed with xcode)

## 💡 Usage

### 🧭 Sample commands

Most of the commands don't have options or arguments, because they extensively use `fzf`.

```zsh
# print main help
dot

# manage submodules (also prints help)
dot submodule
# or an alias
dot sm

# list installed submodules
dot sm ls

# add new submodule
dot sm add https://github.com/filipgodlewski/dot.git

# update submodules
dot sm up

# remove submodule
dot sm rm
```

### ⚙️ Configuration

```zsh
echo $DOTFILES_DATA_HOME
# The default is $HOME/dotfiles
# Override it if your dotfiles are somewhere else

echo $DOTFILES_CONFIG_FILE
# The defult is $DOTFILES_DATA_HOME/config.json
```

The rest of the configurations can and should be managed through the config.json file.

Sample config.json file is provided with this repository.
