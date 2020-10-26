#!/bin/bash
#安装命令补全
source $HOME/xtool/completion/profile

ROOT_PROFILE="$HOME/.profile"


function includeString(){
	echo "$1" | grep -q "$2" && return 0 || return 1
}

#判断shell环境
if includeString "$SHELL" "/bin/zsh"; then
    echo "zsh环境."
	RC_FILE="$HOME/.zshrc"
elif includeString "$SHELL" "/bin/bash"; then
	RC_FILE="$HOME/.bashrc"
	echo "bash环境，开始安装oh-my-zsh"
	#安装oh-my-zsh
	sh -c "$(curl -fsSL https://gitee.com/goingta/xtool/raw/master/oh_my_zsh_install.sh)"
fi

#安装必装插件
#安装 zsh-autosuggestions 插件
FOLDER="$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/"
if [ ! -d "$FOLDER" ]; then
	echo "安装 zsh-autosuggestions"
  	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi


#安装 zsh-syntax-highlighting 插件
FOLDER="$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/"
if [ ! -d "$FOLDER" ]; then
  echo "安装 zsh-syntax-highlighting"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi


#在.profile里面添加source代码
addStringToFile "source $X_PROFILE" $ROOT_PROFILE

#在.zshrc/.bashrc里面添加source代码
addStringToFile "source $ROOT_PROFILE" $RC_FILE

#addStringToFile "env ZSH=$ZSH "'PGTOOLS_AUTO_CHECK=$PGTOOLS_AUTO_CHECK PGTOOLS_AUTO_DAYS=$PGTOOLS_AUTO_DAYS'" zsh -f $HOME/xtool/check_update.sh" 
#$RC_FILE

folders=($(getFolder "$HOME/xtool"))

if [[ "$1" != "" ]]; then
	if [[ -d "$1" ]]; then
		sh "./shell/echoColor.sh" "-yellow" "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
		setupTool $1
		sh "./shell/echoColor.sh" "-yellow" ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
	else
		failedString="$1 not exsit!"
		sh "./shell/echoColor.sh" "-red" "$failedString"
	fi
else
	for folder in ${folders[*]}
	do
	    if test -d $folder
	    then
		    if [ -f "$HOME/xtool/$folder/setup.sh" ]; then
	    		echo $folder | cut -d "/" -f2
	    		sh "./shell/echoColor.sh" "-yellow" "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
				setupTool $folder
				sh "./shell/echoColor.sh" "-yellow" ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
				echo 
			fi
	    fi
	done
fi

# 开启所有安装的插件
HAS_VSCODE=''
FOLDER="$HOME/.oh-my-zsh/custom/plugins/vscode"
if [ -d "$FOLDER" ]; then
	HAS_VSCODE='vscode'
fi
sed -i "" "s/plugins=.*$/plugins=( git z sublime zsh-autosuggestions $HAS_VSCODE zsh_reload colored-man-pages zsh-syntax-highlighting sudo )/" $HOME/.zshrc


sh "./shell/echoColor.sh" "-red" "安装完毕，请重启终端。否则命令不会立即生效!"





