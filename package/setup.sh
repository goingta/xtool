#!/bin/bash
source $HOME/pg_tools/dependency/profile

#是否安装了git
dependency_gem git

#是否安装了xcodeproj 1.4.2
dependency_gem xcodeproj 1.4.2

#是否安装了xcpretty
dependency_gem xcpretty

#安装命令补全
source $HOME/pg_tools/completion/profile
comp_install package _mypkg