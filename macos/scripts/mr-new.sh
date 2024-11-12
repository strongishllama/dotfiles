#!/bin/bash

ME="avonbertoldi"
ISSUE_RE="$ME/([0-9]*)/"
ISSUE=""

LABELS="devops::verify,group::runner,section::ops,runner::core,workflow::ready-for-review"
EXTRA_LABELS=(
	"type::bug"
	"bug::availability"
	"bug::functional"
	"bug::performance"
	"bug::transient"
	"bug::vulnerability"
	"type::feature"
	"feature::addition"
	"feature::enhancement"
	"type::maintenance"
	"maintenance::dependency"
	"maintenance::refactor"
	"maintenance::workflow"
	"security"
)
ELIGIBLE_REVIEWERS=(
    "Ashraf"
    "DarrenEastman"
    "ajwalker"
    "akohlbecker"
    "avonbertoldi"
    "cam_swords"
    "dbickford"
    "gdoyle"
    "ggeorgiev_gitlab"
    "hoegaarden"
    "joe-shaw"
    "josephburnett"
    "jroodnick"
    "nicolewilliams"
    "pedropombeiro"
    "ratchade"
    "tmaczukin"
    "stanhu"
)

function is_in_git_repo() {
	git rev-parse HEAD >/dev/null
}

function get_issue_from_branch() {
	if [[ $CURRENT_BRANCH =~ $ISSUE_RE ]]; then
		ISSUE="${BASH_REMATCH[1]}"
	else
		echo "$CURRENT_BRANCH is not an issue branch"
	fi
}

function get_merge_branch() {
    git upstream | sed 's/origin\///'
}

function main(){
    is_in_git_repo || exit 1

    UPSTREAM=$(git upstream)
    CURRENT_BRANCH=$(git current-branch)

    get_issue_from_branch

    REVIEWERS=$(printf "%s\n" "${ELIGIBLE_REVIEWERS[@]}" | fzf --multi --tac --prompt="Select reviewers >")
    REVIEWERS=$(echo -n "$REVIEWERS" | sed -z 's/[\n ]\+/,/g')

    SELECTED_EXTRA_LABELS=$(printf "%s\n" "${EXTRA_LABELS[@]}" | fzf --multi --tac --prompt="Select additional labels >")
    [[ -n "$SELECTED_EXTRA_LABELS" ]] && LABELS="${LABELS} ${SELECTED_EXTRA_LABELS}"
    LABELS=$(echo -n "$LABELS" | sed -z 's/[\n ]\+/,/g')
    MERGE_BRANCH=$(get_merge_branch)

    args=(mr create --assignee=@me --label "$LABELS" --yes --remove-source-branch --push --fill --fill-commit-body -b "$MERGE_BRANCH")

    [[ -n "$REVIEWERS" ]] && args+=(--reviewer "$REVIEWERS")
    [[ -z "$REVIEWERS" ]] && args+=(--wip)
    # [[ -n "$ISSUE" ]] && args+=(--related-issue "$ISSUE" --copy-issue-labels)

    MILESTONE=$(active_milestone.sh)
    [[ -n "$MILESTONE" ]] && args+=(--milestone "$MILESTONE")

    echo  "${args[@]}"
    glab "${args[@]}"

    git change-upstream "$UPSTREAM"

    [[ -n "$ISSUE" ]] && [[ -n "$REVIEWERS" ]] && glab issue update "$ISSUE" -l "workflow::in review"
}

main