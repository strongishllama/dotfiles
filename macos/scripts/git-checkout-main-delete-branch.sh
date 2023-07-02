#!/bin/bash

REBASED_BRANCH=$(git rev-parse --abbrev-ref HEAD)
export REBASED_BRANCH
git checkout main
git branch --delete "$REBASED_BRANCH"
git pull
