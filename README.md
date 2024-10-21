# Dotfiles

A backup of various configuration and settings files.

# Installation

1. Install Xcode `xcode-select --install`
1. Install [Homebrew](https://brew.sh)
1. Follow the "Next Steps" section in the Homebrew installation output to add Homebrew to PATH
1. Install [1Password](https://formulae.brew.sh/cask/1password)
1. Enable 1Password SSH and CLI in the 1Password developer settings
1. Login to GitHub
1. Download repository
1. Change into `macos` directory
1. Run the `install.sh` script

# Yubikeys

If you need to switch to the backup Yubikey you'll need to update the [work gitconfig](macos/git/.gitconfig.work) to the following.
```sh
signingkey = ~/Developer/personal/dotfiles/macos/ssh/id_ecdsa_work_backup.pub
```
