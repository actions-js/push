#!/bin/sh
set -e

INPUT_USER_EMAIL=${INPUT_USER_EMAIL:-'action@github.com'}
INPUT_USER_NAME=${INPUT_USER_NAME:-'GitHub Action'}
INPUT_BRANCH=${INPUT_BRANCH:-master}
INPUT_FORCE=${INPUT_FORCE:-false}
INPUT_TAGS=${INPUT_TAGS:-false}
INPUT_DIRECTORY=${INPUT_DIRECTORY:-'.'}
_FORCE_OPTION=''
REPOSITORY=${INPUT_REPOSITORY:-$GITHUB_REPOSITORY}

echo "Push to branch $INPUT_BRANCH";
[ -z "${INPUT_GITHUB_TOKEN}" ] && {
    echo 'Missing input "github_token: ${{ secrets.GITHUB_TOKEN }}".';
    exit 1;
};

if ${INPUT_FORCE}; then
    _FORCE_OPTION='--force'
fi

if ${INPUT_TAGS}; then
    _TAGS='--tags'
fi

cd ${INPUT_DIRECTORY}

remote_repo="https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${REPOSITORY}.git"

git config http.sslVerify false
git config --local user.email "${INPUT_USER_EMAIL}"
git config --local user.name "${INPUT_USER_NAME}"

timestamp=$(date -u)

git add -A
git commit -m "chore: autopublish ${timestamp}" || exit 0

git push "${remote_repo}" HEAD:${INPUT_BRANCH} --follow-tags $_FORCE_OPTION $_TAGS;