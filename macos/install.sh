#!/bin/bash

if [ -z "$1" ] || [ "$1" != "work" ] && [ "$1" != "personal" ]; then
    echo "Error: Unexpected argument supplied, expected either 'work' or 'personal', exiting..."
    exit 1
fi

echo "Installing $1 configuration files..."

BASE_URL=~/Developer/personal/repositories/dotfiles/macos

# Create directories.
mkdir -p ~/Developer/personal
if [ "$1" == "work" ]; then
    mkdir -p ~/Developer/work
fi

# Create Git symlinks.
ln -sf $BASE_URL/git/.gitconfig ~/.gitconfig
ln -sf $BASE_URL/git/.gitconfig.personal ~/Developer/personal/.gitconfig
if [ "$1" == "work" ]; then
    ln -sf $BASE_URL/git/.gitconfig.work ~/Developer/work/.gitconfig
fi
ln -sf $BASE_URL/git/.gitignore_global ~/.gitignore_global

# Create SSH symlinks.
ln -sf $BASE_URL/ssh/config ~/.ssh/config

# Create 1Password symlinks.
ln -sf "$BASE_URL/1password/ssh-agent-$1.toml" ~/.config/1Password/ssh/agent.toml
