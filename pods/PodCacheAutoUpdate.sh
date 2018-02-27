#!/bin/sh
source $HOME/pg_tools/profile

# NewCamera360
cd $HOME/.jenkins/jobs/iOS-NewCamera360-Daily/workspace
git fetch --all
default_branch=`git remote show origin | grep "HEAD branch" | cut -d : -f2 | cut -c 2-`
git reset .
git checkout .
git clean -df .
git checkout $default_branch
git pull

rm -rf Pods/
podinstall
git reset .
git checkout .
git clean -df .

# Bestie
cd $HOME/.jenkins/jobs/iOS-Bestie-IPA2/workspace
git fetch --all
default_branch=`git remote show origin | grep "HEAD branch" | cut -d : -f2 | cut -c 2-`
git reset .
git checkout .
git clean -df .
git checkout $default_branch
git pull

rm -rf Pods/
podinstall
git reset .
git checkout .
git clean -df .

# Puzzle
cd $HOME/.jenkins/jobs/iOS-Puzzle-IPA/workspace
git fetch --all
default_branch=`git remote show origin | grep "HEAD branch" | cut -d : -f2 | cut -c 2-`
git reset .
git checkout .
git clean -df .
git checkout $default_branch
git pull

rm -rf Pods/
podinstall
git reset .
git checkout .
git clean -df .


# Finish
cd $HOME/Library/Caches/CocoaPods/Pods
gtci
git pull
git push





