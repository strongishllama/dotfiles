#!/bin/bash

fzf-git-branch() {
    git rev-parse HEAD > /dev/null 2>&1 || return

    git branch --color=always --all --sort=-committerdate |
        grep -v HEAD |
        fzf --height 50% --ansi --no-multi --preview-window right:65% \
            --preview 'git log -n 50 --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed "s/.* //" <<< {})' |
        sed "s/.* //"
}

git rev-parse HEAD > /dev/null 2>&1 || return

BRANCH=""
BRANCH=$(fzf-git-branch)
if [[ "$BRANCH" = "" ]]; then
    echo "No branch selected."
    exit 1
fi

git branch --delete "$BRANCH";
git remote update origin --prune
