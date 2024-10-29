#!/bin/bash

MAIN_BRANCH="unknown"
if [ "$(git rev-parse --verify main 2>/dev/null)" ]; then
    MAIN_BRANCH="main"
elif [ "$(git rev-parse --verify master 2>/dev/null)" ]; then
    MAIN_BRANCH="master"
else
    echo "Unable to determine main branch name"
    exit 1
fi

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
git switch "$MAIN_BRANCH"
git branch --delete "$CURRENT_BRANCH"
git remote update origin --prune
git pull
