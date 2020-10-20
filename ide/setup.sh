#!/bin/bash
if [ -n `which xtool_update` ]; then
    sh "./shell/echoColor.sh" "-yellow" '已配置过IDE'
else
    source $HOME/xtool/ide/profile

    files=("Visual Studio Code" "IntelliJ IDEA" "eclipse" "IntelliJ IDEA CE" "Xcode" "Android Studio")

    menuitems() {
        echo "请选择需要创建别名的IDE："
        for i in ${!files[@]}; do
            printf "%3d%s) %s\n" $((i+1)) "${choices[i]:- }" "${files[i]}"
        done
        [[ "$msg" ]] && echo "$msg"; :
    }

    prompt="请输入序号，多选请以空格隔开："

    while menuitems && read -rp "$prompt" num && [[ "$num" ]]; do
        array=(${num// / })  
        for var in ${array[@]}
        do
            case $var in
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
                    alias ida='ida'
                    sh "./shell/echoColor.sh" "-yellow" 'IntelliJ IDEA 别名已生成，请使用 "ida" 打开工程'
                ;;
                3)  
                    alias ec='ec'
                    sh "./shell/echoColor.sh" "-yellow" 'eclipse 别名已生成，请使用 "ec" 打开工程'
                ;;
                4)  0
                    alias idace='idace'
                    sh "./shell/echoColor.sh" "-yellow" 'IntelliJ IDEA CE 别名已生成，请使用 "idace" 打开工程'
                ;;
                5)  
                    alias x='x'
                    sh "./shell/echoColor.sh" "-yellow" 'Xcode 别名已生成，请使用 "x" 打开工程'
                ;;
                6)  
                    alias as='as'
                    sh "./shell/echoColor.sh" "-yellow" 'Android Studio 别名已生成，请使用 "as" 打开工程'
                ;;
                *)  echo '请选择1-6直接的序号'
                ;;
            esac
        done 
        exit
    done
fi
