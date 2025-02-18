#!/bin/sh

# Check for uncommitted changes (more robust)
if ! git diff-index --quiet HEAD; then
  echo "The working directory is dirty. Please commit any pending changes."
  exit 1
fi

echo "Deleting old publication (if it exists)"
rm -rf public

echo "Checking out gh-pages branch (or creating if it doesn't exist)"
if git show-ref --verify "refs/remotes/origin/gh-pages"; then
  git worktree add -B gh-pages public origin/gh-pages
elif git show-ref --verify "refs/heads/gh-pages"; then # Check local
    git worktree add -B gh-pages public gh-pages
else
  git worktree add -b gh-pages public # Create new gh-pages worktree
fi


echo "Removing existing files in public (important!)"
rm -rf public/*

echo "Generating site"
HUGO_ENV="production" hugo -t github-style

echo "Updating gh-pages branch"
cd public

# More robust git add and commit
git add --all
if ! git diff-index --quiet HEAD; then  # Check if there are changes to commit
    git commit -m "Publishing to gh-pages (publish.sh)"
else
    echo "No changes to commit in public directory."
fi

# Push to GitHub (add error handling)
git push origin gh-pages 2>&1 | tee push.log  # Redirect stderr to stdout and log

if grep -q "Everything up-to-date" push.log; then
    echo "gh-pages branch is up-to-date. No changes pushed."
elif grep -q "remote: Invalid username or password" push.log; then
    echo "Error: Invalid GitHub credentials. Check your username and password."
    exit 1
elif grep -q "Permission denied (publickey)" push.log; then
    echo "Error: Permission denied. Check your SSH key configuration."
    exit 1
elif grep -q "fatal:" push.log; then
    echo "Error: Git push failed. Check the push.log file for details."
    exit 1
else
    echo "Successfully pushed changes to gh-pages branch."
fi

rm push.log # Remove the log file

echo "Deployment complete."