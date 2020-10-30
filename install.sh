#!/bin/bash
if [ ! -d "$HOME/xtool/" ]; then
  mkdir $HOME/xtool/
fi
cd $HOME/xtool/
git clone git@gitlab.aihaisi.com:qiexr/devops/xtool.git
sh setup.sh