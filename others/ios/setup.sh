
source $HOME/xtool/completion/profile

iosFolder=($(getFolder "$HOME/xtool/others/ios"))

for folder in ${iosFolder[*]}
do
    echo $folder
    sh "./shell/echoColor.sh" "-yellow" "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    setupTool "others/ios/$folder"
    sh "./shell/echoColor.sh" "-yellow" ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    echo 
done