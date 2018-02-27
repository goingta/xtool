#!/bin/bash

if [ -f "./Podfile" ]; then
    if [ -z "$1" ]; then
        echo "Usage: podinstall podName, it only update specified pods."
    else
        pods_name=$*
        #判断是否以*结尾
        echo "$1" | grep "\*$"
        if [ $? -eq 0 ]
        then
            #删除*字符
            key=`echo "$1" | awk '{print $1}' | sed -e "s/*//g"`
            #查找pod
            ret=`sed -n "/^  - $key.*:$/p" Podfile.lock | cut -d " " -f4`
            if [ $? -eq 0 ]
            then
                pods_name=$ret
            else
                echo "No pod matched : $1"
                exit 1
            fi
        fi

        echo "=========================================================="
        echo "CocoaPods Will update : \n$pods_name"
        echo "=========================================================="

        conflict_list=`git diff --name-only --diff-filter=U | sed 's/[[:space:]]/_-_/g'`

        confict_podfile_lock=false
        confict_manifest_lock=false
        confict_pod_project=false
        confict_pod_folder=false
        arr=(${conflict_list// / })
        echo $conflict_list
        delete=()
        delete2=()

        # check lock and pod project
        for i in ${arr[@]}
        do
            if [ $i == Podfile.lock* ];then
                confict_podfile_lock=true
            elif [[ $i == Pods/Pods.xcodeproj/project.pbxproj ]] || [[ $i == \"Pods/Pods.xcodeproj/project.pbxproj ]] ;then
                confict_pod_project=true
                delete=($i)
            elif [[ $i == Pods/Manifest.lock ]] || [[ $i == \"Pods/Manifest.lock ]];then
                confict_manifest_lock=true
                delete2=($i)
            fi
        done


        if [ $confict_pod_project = true ];then
            arr=${arr[@]/$delete}
        fi

        if [ $confict_manifest_lock = true ];then
            arr=${arr[@]/$delete2}
        fi

        # check pod folder
        for i in ${arr[@]}
        do
            if [[ $i == Pods/* ]] || [[ $i == \"Pods/* ]];then
                confict_pod_folder=true
            fi
        done


        if [ $confict_podfile_lock = true ];then
            rm -rf ./Podfile.lock
        fi

        if [ $confict_pod_project = true ];then
            rm -rf ./Pods/Pods.xcodeproj/project.pbxproj
        fi

        if [ $confict_manifest_lock = true ];then
            rm -rf ./Pods/Manifest.lock
        fi

        if [ $confict_pod_folder = true ];then
            rm -rf ./Pods
        fi

        currentFolder=`pwd`
        podsRepo='/Users/'`whoami`'/.cocoapods/repos/'
        cd $podsRepo

        for file in `ls`
        do
            if [ ! -d ${podsRepo}${file} ] ; then
                echo " ${podsRepo}${file} is a file"
            else
                cd $file
                originURL=`git config --get remote.origin.url`
                if [[ $originURL != 'git@github.com:CocoaPods/Specs.git' && $originURL != 'https://github.com/CocoaPods/Specs.git' ]];then
                    git pull
                fi
                cd ..
            fi
        done

        cd $currentFolder

        ruby $HOME/pg_tools/pods/ChangePodFile.rb `ls -lrt -d -1 $PWD/Podfile` $pods_name

        x=`ls Gemfile.lock`
        if [[ "$x" = "Gemfile.lock" ]];then
              y=`bundle check`
              if [[ $y != "The Gemfile's dependencies are satisfied" ]];then
                echo "Install Gem Start..."
                bundle install --quiet
                echo "Install Gem Finish..."
              fi
          cmd="bundle exec pod "
        else
          cmd="pod "
        fi
        $cmd update $pods_name --verbose  && \
          find Pods -iname "*.pch" -exec touch -t 01010000 "{}" \; && \
          find Pods -iname "*-dummy.m" -exec touch -t 01010000 "{}" \; && \
          find Pods -iname "*-umbrella.h" -exec touch -t 01010000 "{}" \;



        git add ./Podfile
        git add ./Pods
        git add ./Podfile.lock
        fi
else
    echo No "Podfile" found in the project directory.
fi
