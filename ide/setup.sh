#!/bin/bash

function addStringToFile(){
    profile='source $HOME/xtool/ide/profile'
    ret=$(cat $profile | grep "$@")
    if [ "$ret" = "" ] ;then
        echo "$@">>$profile
    fi
}

if [ -n `which xtool_update` ]; then
    sh "./shell/echoColor.sh" "-yellow" '已配置过IDE'
else

    ides=("Visual Studio Code" "IntelliJ IDEA" "eclipse" "IntelliJ IDEA CE" "Xcode" "Android Studio")

    menuitems() {
        echo "请选择需要创建别名的IDE："
        for i in ${!ides[@]}; do
            printf "%3d%s) %s\n" $((i+1)) "${choices[i]:- }" "${ides[i]}"
        done
        [[ "$msg" ]] && echo "$msg"; :
    }

    prompt="请输入序号，多选请以空格隔开："

    while menuitems && read -rp "$prompt" num && [[ "$num" ]]; do
        array=(${num// / })  
        color="-yellow"
        msg=""
        for index in ${array[@]}
        do
            case $index in
                1)  
                    #安装 zsh-autosuggestions 插件
                    FOLDER="$HOME/.oh-my-zsh/custom/plugins/vscode"
                    if [ ! -d "$FOLDER" ]; then
                        echo "安装 vscode"
                        git clone https://github.com/valentinocossar/vscode.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/vscode
                    fi
                    sh "./shell/echoColor.sh" "-yellow" 'Visual Studio Code 别名已生成，请使用 "vs ." 打开工程'
                ;;
                2)  
                    alias_cmd="alias ida='ida'"
                    msg='IntelliJ IDEA 别名已生成，请使用 "ida" 打开工程'
                ;;
                3)  
                    alias_cmd="alias ec='ec'"
                    msg='eclipse 别名已生成，请使用 "ec" 打开工程'
                ;;
                4)  0
                    alias_cmd="alias idace='idace'"
                    msg='IntelliJ IDEA CE 别名已生成，请使用 "idace" 打开工程'
                ;;
                5)  
                    alias_cmd="alias x='x'"
                    msg='Xcode 别名已生成，请使用 "x" 打开工程'
                ;;
                6)  
                    alias_cmd="alias as='as'"
                    msg='Android Studio 别名已生成，请使用 "as" 打开工程'
                ;;
                *)  echo '请选择1-6直接的序号'
                ;;
            esac
            addStringToFile $alias_cmd 
            sh "./shell/echoColor.sh" $color $msg

        done 
        exit
    done
fi
