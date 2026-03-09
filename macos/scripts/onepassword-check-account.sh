#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $(basename "$0") <work|personal>"
  exit 1
}

[[ $# -ne 1 ]] && usage

PROFILE="$1"

case "$PROFILE" in
  work)
    DESIRED_ACCOUNT="gitlab"
    DESIRED_URL="https://gitlab.1password.com/"
    ;;
  personal)
    DESIRED_ACCOUNT="my.1password.com"
    DESIRED_URL="https://my.1password.com/"
    ;;
  *)
    usage
    ;;
esac

CURRENT_URL="$(op whoami --format=json 2>/dev/null | jq -r '.url // empty' || true)"

if [[ "$CURRENT_URL" != "$DESIRED_URL" ]]; then
  op signin --account "$DESIRED_ACCOUNT"
fi
