#!/bin/bash

function glmr() {
  glab mr create --assignee @me --fill --push --remove-source-branch --yes "$@" | tee >(grep -o 'https://.*' | xargs open)
}

glmr "$@"
