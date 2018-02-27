#!/bin/bash

TOOLS_FOLDER="$HOME/pg_tools"
if [ -d $TOOLS_FOLDER ]; then
	old=$PWD
	cd "$TOOLS_FOLDER" && git pull origin master && sh setup.sh $1
	source profile
	cd $old
else
	str="pg_tools not installed at $HOME/"
	sh "./utility/echoColor.sh" "-red" "$str"
fi
