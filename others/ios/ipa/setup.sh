#!/bin/bash

source $HOME/xtool/others/ios/dependency/profile
dependency_gem rubyzip
dependency_gem sigh

#安装命令补全
source $HOME/xtool/completion/profile
comp_install ipa _myipa