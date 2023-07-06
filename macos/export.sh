#!/bin/bash

cd ./homebrew || exit
rm -rf Brewfile
brew bundle dump --describe
cd ..
