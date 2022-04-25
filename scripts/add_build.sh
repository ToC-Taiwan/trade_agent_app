#!/bin/zsh

git branch --show-current > current_branch

if ! ./scripts/new_build.py
then
  exit 1
fi

mv temp_pubspec.yaml pubspec.yaml
rm current_branch

