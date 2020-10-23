#!/bin/bash
RET="failed"

source $HOME/xtool/dependency/profile

#是否安装了atlassian-stash
dependency_gem atlassian-stash
echo "atlassian-stash installed $RET!"

dependency_brew ruby
echo "ruby installed $RET!"

dependency_gem bundler
echo "bundler installed $RET!"
