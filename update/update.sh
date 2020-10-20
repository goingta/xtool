#!/bin/bash

TOOLS_FOLDER="$HOME/xtool"
if [ -d $TOOLS_FOLDER ]; then
	old=$PWD
	cd "$TOOLS_FOLDER" && git pull origin master && sh setup.sh $1
	source profile
	cd $old
else
	str="xtool not installed at $HOME/"
	sh "./shell/echoColor.sh" "-red" "$str"
fi
