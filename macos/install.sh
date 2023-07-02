#!/bin/bash

BASE_URL=~/Developer/personal/repositories/dotfiles/macos

echo "Creating Git symlinks..."
ln -sf $BASE_URL/git/.gitconfig ~/.gitconfig
ln -sf $BASE_URL/git/.gitconfig.personal ~/Developer/personal/.gitconfig
ln -sf $BASE_URL/git/.gitignore_global ~/.gitignore_global

echo "Creating SSH symlinks..."
ln -sf $BASE_URL/ssh/config ~/.ssh/config
