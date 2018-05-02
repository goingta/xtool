#!/bin/sh

#添加全局hooks模板
GIT_TEMPLATES_DIRECTORY="/Applications/GitHub.app/Contents/Resources/git/share/git-core/templates"
cp -r $HOME/xtool/git/commit-msg "$GIT_TEMPLATES_DIRECTORY/hooks"
cp -r $HOME/xtool/git/pre-commit "$GIT_TEMPLATES_DIRECTORY/hooks"
git config --global init.templatedir $GIT_TEMPLATES_DIRECTORY


#安装命令补全
source $HOME/xtool/completion/profile
comp_install git _mygit1
comp_install git _mygit2