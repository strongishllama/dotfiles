#!/bin/bash

function glmr() {
  glab mr create --assignee @me --reviewer GitLabDuo --fill --push --remove-source-branch --yes "$@" | tee >(grep -o 'https://.*' | xargs open)
}

glmr "$@"
