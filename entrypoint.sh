#!/bin/sh

# a github token is needed to grant 
# push priviledges for the current repo
if [ -z "${GITHUB_TOKEN}" ]; then
    echo "error: not found GITHUB_TOKEN"
    exit 1
fi

repository="https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"

git config http.sslVerify false
git config user.name "Push Bot"
git config user.email "actions@users.noreply.github.com"
git remote add publisher "${repository}"

git show-ref
git branch --verbose

# publish any new files
git checkout master
git add -A

timestamp=$(date -u)
git commit -m "Automated push: ${timestamp} ${GITHUB_SHA}" || exit 0

git pull --rebase publisher master
git push publisher master