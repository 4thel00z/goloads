#! /usr/bin/env sh

echo "::debug::entrypoint-git.sh"
echo "::debug::Args are $@"
echo "::debug::Running git clone $1 /repo"
git clone $1 /repo
echo "::debug::Running ls on /repo: $(ls /repo)"
