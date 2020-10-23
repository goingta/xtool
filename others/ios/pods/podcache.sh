#!/bin/sh


if [ ! -d "$HOME/Library/Caches/CocoaPods/Pods/.git" ]; then
	 echo "Init Cocoapods Cache"
 	 cd $HOME/Library/Caches/CocoaPods
  	 rm -rf Pods/
  	 git clone ssh://git@mobiledev.camera360.com:7999/coc/cache.git Pods --depth 1
else
	echo "Pull Cocoapods Cache"
  	cd $HOME/Library/Caches/CocoaPods/Pods/
  	git pull
fi
