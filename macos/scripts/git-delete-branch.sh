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

branch=$(fzf-git-branch)
if [[ "$branch" = "" ]]; then
    echo "No branch selected."
    return
fi

git branch -d "$branch";