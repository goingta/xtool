# if [ -n `which xtool_update` ]; then
#     sh "./shell/echoColor.sh" "-yellow" '已配置过IDE'
# else
    source $HOME/xtool/completion/profile
    others=($(getFolder "$HOME/xtool/others"))
    others+=("不用了")  
    menuitems() {
        echo "是否需要安装其他专属工具："
        for i in ${!others[@]}; do
            printf "%3d%s) %s\n" $((i+1)) "${choices[i]:- }" "${others[i]}"
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
            item="${others[$index-1]}"
            filePath="$HOME/xtool/others/$item/setup.sh"
            if [ item != "不用了" ] && [ -f "$filePath" ];then
                sh $filePath
            fi
            
        done
        exit 
    done
# fi
