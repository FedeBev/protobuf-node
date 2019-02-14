#!/bin/bash

set -e

TAG_REGEX="^p(([0-9]+.){2}[0-9]+)-n(([0-9]+.){2}[0-9]*)$"

VERSION=$1

if [[ ! -z $(git status -s) ]]; then
  echo "[ERR] Index contains uncommited changes, please commit or stash them before release!"
  exit 1
fi

echo "[INFO] Ensuring that flow is enabled"
# Git-flow settings
git flow init -df
git config gitflow.release.finish.notag true

echo "[INFO] Checking branch name"
branch_name=$(git symbolic-ref -q HEAD)
branch_name=${branch_name##refs/heads/}
branch_name=${branch_name:-HEAD}


echo "[DEBUG] Current branch is '$branch_name'"

if [ "$branch_name" != "develop" ]; then
    echo "[ERR] Move to delevop branch to start a new release"
    exit 1
fi

if [[ -z $(git status -s) ]]; then
  echo "tree is clean"
else
  echo "tree is dirty, please commit changes before running this"
  exit
fi

if [ ! $VERSION =~ $TAG_REGEX ]; then
    echo "[ERR] Tag is invalid, must feat regex '$TAG_REGEX' (example: p3.6.1-n10.14.1)"
    exit 1
fi

echo "[INFO] Version '${VERSION}' is valid, starting release branch"
git flow release start $VERSION

echo "[INFO] Generating changelog for release ${VERSION}"
npx auto-changelog --tag-pattern "${TAG_REGEX}" -l 10 -b 10

echo "[INFO] Committing changelog file"
git add .
git commit -m "doc: Changelog for release ${VERSION}"

echo "[INFO] Closing release"
git flow release finish $VERSION

echo "[INFO] Switching on master branch"
git checkout master -q

echo "[INFO] Tagging release"
git tag -a "${VERSION}" -m "Release for version $VERSION"
git tag -a "${VERSION}-slim" -m "Slim release for version $VERSION"
git tag -a "${VERSION}-alpine" -m "Alpine release for version $VERSION"

echo "[INFO] Switching on master develop"
git checkout develop -q

echo "[INFO] All done!"