#!/usr/bin/env ruby

require 'pathname'

folder_name = Pathname.new(File.dirname(ARGV[0])).realpath

Dir.chdir(folder_name)

full_path = ARGV.shift
text = IO.read(full_path)

pod_names = ARGV

# 如果为空, 则选出所有无版本号的Pod名称
if pod_names.count == 0
  text.gsub!(/\s*,/, ",").scan(/\n*\s*pod\s+['"][^'"]+['"]\s*(?!,\s*)+\s*/) do |item|
    item.scan(/['"](.+)['"]/) do |item2|
      pod_names.push(item2[0].gsub(/\/.*/, ''))
    end
  end
end


pod_names_new = Array.new

pod_names.each do |pod|
  pod_names_new.push pod.sub(/\/[a-zA-Z0-9_\-]+/,'')
end



pod_names = pod_names_new.uniq


p "=========================================================="
p "CocoaPods Will update : \n #{pod_names}"
p "=========================================================="

pod_names.each do |pod|
  latest_version = `x=\`ls Gemfile.lock\`
if [[ "$x" = "Gemfile.lock" ]];then
    y=\`bundle check\`
  if [[ $y != "The Gemfile's dependencies are satisfied" ]];then
              #echo "Install Gem Start..."
    bundle install --quiet
              #echo "Install Gem Finish..."
  fi

  cmd="bundle exec pod search "
else
  cmd="pod search "
fi
if [[ \`$cmd --version\` != "0.38.2" ]];then
  cmd=$cmd" --simple"
fi

$cmd --regex '^#{pod}$' --verbose | more | grep \\~\\> | awk '{print $4}' | rev | cut -c 2- | rev`.delete!("\n")

  # 有具体版本号的, 直接修改为最新版本号
  pod_items = Array.new
  pod_origin = Array.new
  text.scan(/^\n*\s*pod\s+['"]#{pod}(?!a-zA-Z0-9_\-)[\/'"a-zA-Z0-9_\-+]+[a-zA-Z0-9_\-+]*\s*,\s*['"][0-9\.]+['"]\s*\n*$/) do |item|
    item.scan(/pod\s+['"]([a-zA-Z0-9_\-\/\+]+)['"]/) do |item2|
      # 避免前缀一样的被匹配上
      if item2[0].eql?(pod) || item2[0].include?('/')
        pod_items.push(item.strip)
        origin = item.match(/(\s*pod\s+['"]#{pod}[\/]*[a-zA-Z0-9_\-+]*['"]\s*),\s*['"][0-9\.]+['"]\s*/).captures[0]
        pod_origin.push(origin.strip)
      end
    end
  end

  pod_items.each_index do |index|
    if latest_version
      text.gsub!(pod_items[index], pod_origin[index]+", '"+ latest_version+"'")
    else
      p 'Wrong version'
      p pod_items[index]
      p pod_origin[index]
    end
  end
end

pod_names.each do |pod|
  latest_version = `x=\`ls Gemfile.lock\`
if [[ "$x" = "Gemfile.lock" ]];then
    y=\`bundle check\`
  if [[ $y != "The Gemfile\'s dependencies are satisfied" ]];then
                              #echo "Install Gem Start..."
    bundle install --quiet
                              #echo "Install Gem Finish..."
  fi

  cmd="bundle exec pod search "
else
  cmd="pod search "
fi
if [[ \`$cmd --version\` != "0.38.2" ]];then
  cmd=$cmd" --simple"
fi

$cmd --regex '^#{pod}$' --verbose | more | grep \\~\\> | awk '{print $4}' | rev | cut -c 2- | rev`.delete!("\n")
  # 无具体版本号的, 直接添加最新版本号
  # text.gsub!(/(pod\s+['"]#{pod}[\/'"a-zA-Z0-9_\-+]+[a-zA-Z0-9_\-+]*)\s*(?!,)\s*$/, "\\1, '" + latest_version +"'")
  text.gsub!(/(pod\s+['"]#{pod}[\/'"a-zA-Z0-9_\-+]+[a-zA-Z0-9_\-+]*)\s*(,)\s*(['"])([0-9]\.)+([0-9])+(['""])/, "\\1, '" + latest_version +"'")
end

File.open(full_path, 'w') { |file3| file3.puts text }
