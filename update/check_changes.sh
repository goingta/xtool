#!/usr/bin/env zsh

TOOLS_FOLDER="$HOME/xtool"

old=$PWD

cd "$TOOLS_FOLDER"

git fetch git@github.com:PGClient/xtool.git master --quiet >/dev/null 2>&1

if [[ $? -eq 0 ]]; then
	#git log --oneline FETCH_HEAD ^master>$TOOLS_FOLDER/.tools-changes
	git log --pretty=format:"%h [%an] : %s" -n 1 FETCH_HEAD ^master>$TOOLS_FOLDER/.tools-changes
fi

cd $old