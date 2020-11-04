# 安装
emmm，由于github会遇到 `failed to connect to raw.githubusercontent.com port 443 connection refused`，gitlab会先去鉴权。目前暂时把安装文件放到gitee上

## 1.安装Oh my zsh

> sh -c "$(curl -fsSL https://gitee.com/goingta/xtool/raw/master/oh_my_zsh_install.sh)"

## 2.安装xtool

|  Method   | Command  |
|  ----  | ----  |
| curl  | sh -c "$(curl -fsSL https://gitee.com/goingta/xtool/raw/master/install.sh)" |
| wget  | sh -c "$(wget -O- https://gitee.com/goingta/xtool/raw/master/install.sh)" |
| fetch | sh -c "$(fetch -o - https://gitee.com/goingta/xtool/raw/master/install.sh)"|

# 通用
## oh my zsh
如果是bash环境会安装oh my zsh，oh my zsh自带了很多插件，然后会额外安装zsh-autosuggestions和zsh-syntax-highlighting两个插件。并且配置打开所有安装过的以及自带的部分好用的插件，查看插件配置步骤：打开`~/.zshrc`文件找到`plugins=( git )`
具体配置如下：
> plugins=( git z sublime zsh-autosuggestions zsh_reload colored-man-pages zsh-syntax-highlighting sudo )

注，如果是前端的话会多一个vscode：
> plugins=( git z sublime zsh-autosuggestions vscode zsh_reload colored-man-pages zsh-syntax-highlighting sudo )

### zsh-autosuggestions
非常好用的一个插件，会记录你之前输入过的所有命令，并且自动匹配你可能想要输入命令，然后按→补全

### zsh-syntax-highlighting
命令太多，有时候记不住，等输入完了才知道命令输错了，这个插件直接在输入过程中就会提示你，当前命令是否正确，错误红色，正确绿色

### z
这个是oh-my-zsh默认就装好的，需要自己开启。还有一个autojump的插件和z功能差不多，autojump需要单独装，如果z插件历史记录太多，并且有一些不是自己想要的，可以删除

> z -x 不要的路径

## git
这个是装好oh-my-zsh就默认已经开启的，然后也根据团队需要扩充了一些命令，方便做版本，分支管理查看所有oh my zsh自带的git命令alias。
> ~/.oh-my-zsh/plugins/git/git.plugin.zsh

这里把大部分贴出来，随着版本更新可能会有变化：

```
#扩充的命令

gamx (原来emac封装的 gitx commit 命令)

gam (git add . && git commit -m "xxx")

glm (等同于从"主"分支git pull & merge到当前分支)

gmr (往gitlab上发pull request)

#以下是oh my zsh自带的
g - git

gl - git pull

gst - git status

gp - git push

gd - git diff

gdc - git diff --cached

gdv - git diff -w "$@" | view

gc - git commit -v

gc! - git commit -v --amend

gca - git commit -v -a

gca! - git commit -v -a --amend

gcmsg - git commit -m

gco - git checkout

gcm - git checkout master

gr - git remote

grv - git remote -v

grmv - git remote rename

grrm - git remote remove

gsetr - git remote set-url

grup - git remote update

grbi - git rebase -i

grbc - git rebase --continue

grba - git rebase --abort

gb - git branch

gba - git branch -a

gcount - git shortlog -sn

gcl - git config --list

gcp - git cherry-pick

glg - git log --stat --max-count=10

glgg - git log --graph --max-count=10

glgga - git log --graph --decorate --all

glo - git log --oneline --decorate --color

glog - git log --oneline --decorate --color --graph

gss - git status -s

ga - git add

gm - git merge

grh - git reset HEAD

grhh - git reset HEAD --hard

gclean - git reset --hard && git clean -dfx

gwc - git whatchanged -p --abbrev-commit --pretty=medium

gsts - git stash show --text

gsta - git stash

gstp - git stash pop

gstd - git stash drop

ggpull - git pull origin $(current_branch)

ggpur - git pull --rebase origin $(current_branch)

ggpush - git push origin $(current_branch)

ggpnp - git pull origin $(current_branch) && git push origin $(current_branch)

glp - _git_log_prettily

```

## XP-Portal
根据xp-portal的目前分支版本流程扩充的命令
```
1. xpid xxx //添加xp-portal的应用id
2. xpmr //提交代码后，打开浏览器进入xp-portal提交merge request流程
```

## IDE
安装的时候会提示，需要安装那些快捷键。根据自己的需要安装就可以了。

### IntelliJ IDEA
封装过的命令，需要打开工程文件的话，只需要在工程目录下面输入：
> ida

### IntelliJ IDEA CE
也是封装过的命令，需要打开工程文件的话，只需要在工程目录下面输入：
> idace

### eclipse
需要打开工程文件的话，只需要在工程目录下面输入：
> ec

### Android Studio
需要打开工程文件的话，只需要在工程目录下面输入：
> as

### sublime
又是一个自带的插件，同样需要自己开启，针对喜欢用sublime的小伙伴，如果想要用sublime打开一个文件。
> st 文件路径

### vscode
随着Visual Studio Code越来越火，用的人也越来越多，可以装一下这个插件,打开一个文件。
> vs 文件路径

### xcode
快速打开当前目录下的iOS工程（打开*.xcworkspace或*.xcodeproj）
> x

## shell

change shell to zsh

	sh setup.sh

# 根据职能可选模块
## iOS

### localizable
封装国际化快速转义的命令，将excel文件快速转成对应国家的string file
```
locinit //init configrure in  localizable folder
loc2s //把xls文件转换成strings file
loc2x //把strings file 转换成xls文件
lochelp //show help info
```
	
### package
修改iOS工程配置的快捷命令
```
pkg -write //配置example configuration
pkg -read //查看本地某一个configuration的config file
pkg -env dev.cfg //根据config file修改xcode project configuration
pkg -build //Build xcode project

pkg -build Debug //根据debug 或 Release， Build xcode project
pkg -clean // Clean xcode project
pkg -make //Make ipa file
pkg -bat //Batch make ipa file
```

### mptools
管理和查看iOS工程需安装的provisionprofile file文件
```
mplist //查看所有provisionprofile file
mpclean //清除所有provisionprofile file
mpinstall xxxx.provisionprofile //安装某一个provisionprofile file
mpinstall ./provisionprofileFolder //安装文件夹下所有的安装某一个provisionprofile file
```

### pods
为Cocoapods扩充的快捷命令
```
ppi - pod install
ppu - pod update
```
## Web
配置前端的fastlane-cli命令
```
xt_create_project='fl create'
xt_preview_weapp='fl weapp preview'
xt_lint='fl lint'
xt_tool='fl tool'
```
	

   
