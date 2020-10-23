#!/usr/bin/env ruby

require 'pathname'



file_name = Pathname.new(File.dirname(ARGV[0])).realpath

tag_text = ARGV[1]

puts ARGV[0]

Dir.chdir(file_name)

all_text_files = Dir.glob "*.podspec"

main_final_version = ""

all_text_files.each { |file2|
  full_path = file_name.to_s() +'/'+file2
  text = IO.read(full_path)

  text.scan(/(\s*[a-zA-Z0-9_]+\.version\s*=\s*['"][0-9.]+['"]\s*)/) do |old_version|
    old_version.kind_of?(Array) ? old_version = old_version[0] : old_version = old_version

    lastOneInt = old_version.match(/.*\.(\d+)/).captures[0]
    lastInt2 = (lastOneInt.to_i() + 1).to_s
    final_version = old_version.sub(/\.(\d+)(['"])/) { |word| '.'+lastInt2+$2 }


    if main_final_version.empty?

      main_final_version = final_version.match(/['"]([0-9.]+)['"]/).captures[0].slice!(0..-1)

      text.scan(/.*\.source\s+=\s*\{\s*:git *=> *['"].*['"] *}/) do |old_tag|
        old_tag.kind_of?(Array) ? old_tag = old_tag[0] : old_tag = old_tag
        text.scan(/.*\.source\s+=\s*\{\s*:git *=> *['"].*git['"] */) do |orl_prefix|
          text = text.sub(old_tag, orl_prefix + ', :tag => "' + main_final_version + '"}')
        end
      end
    end
    text = text.sub(old_version, final_version)
  end

  File.open(full_path, 'w') { |file3| file3.puts text }

  # 获取当前目录是哪个基础库的
  git_path = `git config --get remote.origin.url`
  repo_name = ""
  if git_path.include? "/pglib/"
    repo_name = "PGLib"
  elsif git_path.include? "/hlib/"
    repo_name = "PGLib"
  elsif git_path.include? "/loco/"
    repo_name = "PGLib"
  elsif git_path.include? "/pgkit/"
    repo_name = "PGKit"
  elsif git_path.include? "/PGImage/"
    repo_name = "PGKit"
  else
    repo_name = "Libs"
  end



  # 获取基础库地址
  base_path="#{Dir.home}/.cocoapods/repos/"
  dir = Dir.open(base_path)
  repo_hash = {}
  while name = dir.read
    folder = base_path+name
    next if name == "."              # 忽略当前目录
    next if name == ".."             # 忽略上级目录
    if File.directory?(folder)
      git_path = `cd #{folder} && git config --get remote.origin.url`
      if git_path.include? "/pglib/"
        repo_hash["PGLib"] = name
      elsif git_path.include? "/pgks/"
        repo_hash["PGKit"] = name
      else
        repo_hash["Libs"] = name
      end
    end
  end


  system 'unset GIT_DIR && git pull'
  system 'git add *.podspec'
  system 'git commit -m "update the %s"' % repo_name
  if tag_text.nil? then
    puts "begin push tags no comments: #{tag_text}"
    system ('git tag ' + main_final_version)
  else

    temp_tag_text = "\"#{tag_text}\""
     puts "begin push tags has comments: #{tag_text}"
    system ('git tag ' + main_final_version + ' -m ' + temp_tag_text)
  end


  system 'git push --all'
  system 'git push --tags'
  system 'x=`ls Gemfile.lock`
if [[ "$x" = "Gemfile.lock" ]];then
  y=`bundle check`
  if [[ $y != "The Gemfile\'s dependencies are satisfied" ]];then
    #echo "Install Gem Start..."
    bundle install --quiet
    #echo "Install Gem Finish..."
  fi
  cmd="bundle exec pod "
else
  cmd="pod "
fi
$cmd repo push %s --allow-warnings --verbose --use-libraries' % repo_hash[repo_name]
}
