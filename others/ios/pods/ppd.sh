#!/bin/bash

if [ -f "./Podfile" ]; then
	rm -Rf ./Pods/
	rm ./Podfile.lock
else
	echo No "Podfile" found in the project directory.
fi
