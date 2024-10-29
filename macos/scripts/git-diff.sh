#!/bin/bash

function gd() {
    # Show tracked changes
    git diff HEAD
    # Show untracked files
    git ls-files --others --exclude-standard -z | xargs -0 -I {} git diff --no-index /dev/null {}
}

gd
