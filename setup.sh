#!/bin/bash

ROOT_PROFILE="$HOME/.profile"
X_PROFILE="$HOME/xtool/profile"


function includeString(){
	echo "$1" | grep -q "$2" && return 0 || return 1
}

#判断shell环境
if includeString "$SHELL" "/bin/zsh"; then
	RC_FILE="$HOME/.zshrc"
elif includeString "$SHELL" "/bin/bash"; then
	RC_FILE="$HOME/.bashrc"
	#安装oh-my-zsh
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

#安装 zsh-autosuggestions 插件
FOLDER="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
if [ ! -x "$folder"]; then
	echo "安装 zsh-autosuggestions"
  	sh "git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
fi


#安装 zsh-syntax-highlighting 插件
FOLDER="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
if [ ! -x "$folder"]; then
  echo "安装 zsh-syntax-highlighting"
  sh "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"	
fi

function addStringToFile(){
	ret=$(cat $2 | grep "$1")
	if [ "$ret" = "" ] ;then
		echo "
$1
	">>$2

	echo "[source] \"$1\" ---> \"$2\"."
	fi
}

function setupTool(){
	addStringToFile 'source $HOME/xtool/'$1"/profile" $X_PROFILE
	sh "$HOME/xtool/$1/setup.sh"
	successString="$1 setup success !"
	sh "./shell/echoColor.sh" "-green" "$successString"
}

#在.profile里面添加source代码
addStringToFile "source $X_PROFILE" $ROOT_PROFILE

#在.zshrc/.bashrc里面添加source代码
addStringToFile "source $ROOT_PROFILE" $RC_FILE

#addStringToFile "env ZSH=$ZSH "'PGTOOLS_AUTO_CHECK=$PGTOOLS_AUTO_CHECK PGTOOLS_AUTO_DAYS=$PGTOOLS_AUTO_DAYS'" zsh -f $HOME/xtool/check_update.sh" 
#$RC_FILE

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
	for file in ./*
	do
	    if test -d $file
	    then
		    if [ "$file" != "./shell" ] && [ "$file" != "./git" ]; then
	    		echo $file | cut -d "/" -f2
	    		sh "./shell/echoColor.sh" "-yellow" "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
				setupTool $file
				sh "./shell/echoColor.sh" "-yellow" ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
				echo 
			fi
	    fi
	done
fi


