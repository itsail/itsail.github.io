#!/bin/bash

tmp="${HOME}/build_tmp"
files="_site"

develop="develop"
public="master"

mkdir $tmp
git checkout $develop
JEKYLL_ENV=production jekyll build && cp -r $files/* $tmp

read -r -p "Your commit: " commit
git add .
git commit -a -m "$commit"
git push origin $develop

git checkout $public
rm -rf *
rm -rf .sass-cache
cp -r $tmp/* .
git add .
git commit -a -m "$commit"
git push origin $master

rm -rf $tmp
git checkout $develop
