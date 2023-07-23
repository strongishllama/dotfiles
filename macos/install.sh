#!/bin/bash

if [ -z "$1" ] || [ "$1" != "work" ] && [ "$1" != "personal" ]; then
    echo "Error: Unexpected argument supplied, expected either 'work' or 'personal', exiting..."
    exit 1
fi

echo "Installing $1 configuration files..."

BASE_URL="$(pwd)"

# Create directories.
mkdir -p "$HOME/bin"
mkdir -p "$HOME/.nvm"
mkdir -p "$HOME/.ssh"
mkdir -p "$HOME/.config/1Password/ssh"
mkdir -p "$HOME/.config/nvim"
mkdir -p "$HOME/Developer/personal"
if [ "$1" == "work" ]; then
    mkdir -p "$HOME/Developer/work"
fi

# Create script symlinks.
rm -rf "$HOME/scripts" || true
ln -sf "$BASE_URL/scripts" "$HOME/scripts"
"$HOME/scripts/enable-sudo-touch-id.sh"

# Create Git symlinks.
ln -sf "$BASE_URL/git/.gitconfig" "$HOME/.gitconfig"
ln -sf "$BASE_URL/git/.gitconfig.personal" "$HOME/Developer/personal/.gitconfig"
if [ "$1" == "work" ]; then
    ln -sf "$BASE_URL/git/.gitconfig.work" "$HOME/Developer/work/.gitconfig"
fi
ln -sf "$BASE_URL/git/.gitignore_global" "$HOME/.gitignore_global"
ln -sf "$BASE_URL/zsh/.zshrc" "$HOME/.zshrc"

# Create SSH symlinks.
ln -sf "$BASE_URL/ssh/config" "$HOME/.ssh/config"

# Create 1Password symlinks.
ln -sf "$BASE_URL/1password/ssh-agent-$1.toml" "$HOME/.config/1Password/ssh/agent.toml"

# Create Neovim symlinks.
ln -sf "$BASE_URL/nvim" "$HOME/.config/nvim"

# Add Cronjobs.
crontab -r; crontab -l | { cat; echo "@reboot $HOME/scripts/enable-sudo-touch-id.sh"; } | crontab -

# Install software.
brew bundle --file="$BASE_URL/homebrew/Brewfile"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
