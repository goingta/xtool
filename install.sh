#!/bin/bash
if [ ! -d "$HOME/xtool/" ]; then
  mkdir $HOME/xtool/
fi
cd $HOME/xtool/
git clone git@github.com:goingta/xtool.git
sh setup.sh