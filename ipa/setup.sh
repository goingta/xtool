#!/bin/bash

source $HOME/pg_tools/dependency/profile
dependency_gem rubyzip
dependency_gem sigh

#安装命令补全
source $HOME/pg_tools/completion/profile
comp_install ipa _myipa