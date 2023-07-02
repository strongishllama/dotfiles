#!/bin/bash

if [ -z "$1" ] || [ "$1" != "work" ] && [ "$1" != "personal" ]; then
    echo "Error: Unexpected argument supplied, expected either 'work' or 'personal', exiting..."
    exit 1
fi

echo "Installing $1 configuration files..."

BASE_URL=$HOME/Developer/personal/repositories/dotfiles/macos

# Create directories.
mkdir -p ~/Developer/personal
if [ "$1" == "work" ]; then
    mkdir -p ~/Developer/work
fi

# Create script symlinks.
trash "$HOME/scripts"
ln -sf "$BASE_URL/scripts" "$HOME/scripts"
"$HOME/scripts/enable-sudo-touch-id.sh"

# Create Git symlinks.
ln -sf "$BASE_URL/git/.gitconfig" "$HOME/.gitconfig"
ln -sf "$BASE_URL/git/.gitconfig.personal" "$HOME/Developer/personal/.gitconfig"
if [ "$1" == "work" ]; then
    ln -sf "$BASE_URL/git/.gitconfig.work" "$HOME/Developer/work/.gitconfig"
fi
ln -sf "$BASE_URL/git/.gitignore_global" "$HOME/.gitignore_global"

# Create SSH symlinks.
ln -sf "$BASE_URL/ssh/config" "$HOME/.ssh/config"

# Create 1Password symlinks.
ln -sf "$BASE_URL/1password/ssh-agent-$1.toml" "$HOME/.config/1Password/ssh/agent.toml"

# Add Cronjobs.
crontab -r; crontab -l | { cat; echo "@reboot $HOME/scripts/enable-sudo-touch-id.sh"; } | crontab -

# Install software.
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
