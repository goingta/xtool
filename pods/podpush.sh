#!/bin/bash


#老上传代码
function podpush_old() {

	if [ -n "`ls *.podspec`" ]; then
		git pull origin
		ruby $HOME/pg_tools/pods/BumpPodSpecVersion.rb `ls -lrt -d -1 $PWD/*.podspec` $1
	else
		echo No "podspec" found in the project directory.
	fi
}

# 新方法上传，从Docs拷贝对应参数
function podpush_gamr() {

  strType=$1

  if [[ -n $strType ]]; then

    ## copy文件
    strDoc="Docs"
    strPathPWD=`pwd`
    strName=${strPathPWD##*/}
    echo ">>>>>>>>>>>>>>>>>>>>>> ${strName}"
    strDocPodspec="${strDoc}/${strName}_${strType}.podspec"
    strAllDocPodspec="${strPathPWD}/${strDocPodspec}"
    echo $strAllDocPodspec
    if [[ ! -f "$strAllDocPodspec" ]]; then

      echo "Error: 没有找到 ${strDocPodspec}"
    else

      echo " 找到 ${strDocPodspec}"
      strPodspec="${strName}.podspec"
      echo "拷贝 ${strDocPodspec} -> ${strPodspec}"
      rm -rf ${strPodspec}
      cp -a ${strDocPodspec} ${strPodspec}


      git add . && git add -u && git commit -m "podpush_gamr ${strType} $2"
      git pull
      # ruby Scripts/BumpPodSpecVersion.rb
      podpush_old $2
      git push

      echo "拷贝 ${strPodspec} -> ${strDocPodspec}"
      rm -rf ${strDocPodspec}
      cp -a ${strPodspec} ${strDocPodspec}

      rm -rf *.h
      rm -rf *.hpp

      git add . && git add -u && git commit -m "podpush_gamr end $2"
      git push

    fi

  else

    git add . && git add -u && git commit -m"podpush_gamr $2"
    git pull
    # ruby Scripts/BumpPodSpecVersion.rb
    podpush_old $2
    git push

  fi
}

# 连续上传2个 podspec
function podpush_02() {
  date_start=$(date +%s)

  podpush_gamr 2 $1
  podpush_gamr 0 $1


  date_end=$(date +%s)
  time1=`expr "$date_end" - "$date_start"`
  echo "your command will take $time1 seconds"
}



echo "使用新版本的podpush 1.0"

git pull origin

if [[ -n "`ls pg_sdk_*.podspec`"  &&  -z "`ls pg_sdk_t_pinguo_image_controller.podspec`" ]]; then

	echo "检测到 pg_sdk_*.podspec 使用新模式上传"
	podpush_02 $1
else

  if [ -n "`ls PTL_*.podspec`" ]; then

    echo "检测到 PTL_*.podspec 使用新模式上传"
    podpush_02 $1
  else

    echo "使用老模式上传"
    podpush_old $1
  fi
fi

# 发声
echo $'\07'; sleep 1; echo $'\07'; sleep 1;  echo $'\07'; sleep 1; echo $'\07'; sleep 1; echo $'\07';
