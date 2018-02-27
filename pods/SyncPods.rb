# 检查基础库Specs是否都已正确 clone
base_path="#{Dir.home}/.cocoapods/repos/"
dir = Dir.open(base_path)
repo_hash = {}
repo_contents = {}
while name = dir.read
  folder = base_path+name
  next if name == "."              # 忽略当前目录
  next if name == ".."             # 忽略上级目录
  if File.directory?(folder)
    git_path = `cd #{folder} && git config --get remote.origin.url`
    if git_path.include? "/pglib/"
      repo_hash["PGLib"] = name
      repo_contents["PGLib"] = Dir.entries(folder+"/Specs").delete_if{|x| x.start_with?('.')}
    elsif git_path.include? "/pgks/"
      repo_hash["PGKit"] = name
      repo_contents["PGKit"] = Dir.entries(folder).delete_if{|x| x.start_with?('.')}
    end
  end
end

# 如果没 clone 就 clone 一次
unless repo_hash.has_key? "PGLib"
  system 'cd %s
  x=`ls Gemfile.lock`
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
$cmd repo add PGLib ssh://git@mobiledev.camera360.com:7999/pglib/pglibspecs.git' % base_path
  repo_contents["PGLib"] = Dir.entries(base_path+"/PGLib"+"/Specs").delete_if{|x| x.start_with?('.')}
end

unless repo_hash.has_key? "PGKit"

  system 'cd %s
    x=\`ls Gemfile.lock\`
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
  $cmd repo add PGKit ssh://git@mobiledev.camera360.com:7999/pgks/pgkitspecs.git' % base_path
  repo_contents["PGKit"] = Dir.entries(base_path+"/PGKit").delete_if{|x| x.start_with?('.')}
end

# 检查本地是否有 Specs 目录

wd = ARGV[0] ? ARGV[0] : Dir.getwd
if File.directory?(wd+"/PGLib")
  root_spec = wd
  pglib_spec = root_spec+"/PGLib"
  pgkit_spec = root_spec+"/PGKit"
elsif File.directory?(wd+"/../../Specs")
  root_spec = File.expand_path("../../Specs", wd)
  pglib_spec = root_spec+"/PGLib"
  pgkit_spec = root_spec+"/PGKit"
elsif File.directory?(wd+"/../../../Specs")
  root_spec = File.expand_path("../../../Specs", wd)
  pglib_spec = root_spec+"/PGLib"
  pgkit_spec = root_spec+"/PGKit"
else
  root_spec = wd+"/Specs"
  pglib_spec = root_spec+"/PGLib"
  pgkit_spec = root_spec+"/PGKit"
end

unless File.directory?(root_spec)
  Dir.mkdir(root_spec)
end

unless File.directory?(pglib_spec)
  Dir.mkdir(pglib_spec)
end

unless File.directory?(pgkit_spec)
  Dir.mkdir(pgkit_spec)
end

repo_contents["PGLib"].each do |item|
  unless File.directory?(pglib_spec+"/"+item)
    system "cd %s && git clone 'ssh://git@mobiledev.camera360.com:7999/pglib/%s.git' %s" % [pglib_spec, item, item]
    system "cd %s && git clone 'ssh://git@mobiledev.camera360.com:7999/hlib/%s.git' %s" % [pglib_spec, item, item]
    system "cd %s && git clone 'ssh://git@mobiledev.camera360.com:7999/LOCO/%s.git' %s" % [pglib_spec, item, item]
  end
end

repo_contents["PGKit"].each do |item|
  unless File.directory?(pgkit_spec+"/"+item)
    system "cd %s && git clone 'ssh://git@mobiledev.camera360.com:7999/pgkit/%s.git' %s" % [pgkit_spec, item, item]
  end
end

# 进入子目录, 并都更新一遍
system "cd %s && find . -maxdepth 1 -type d -exec sh -c '(cd {} && pwd && git pull --all)' ';'" % pglib_spec+"/Specs"
system "cd %s && find . -maxdepth 1 -type d -exec sh -c '(cd {} && pwd && git pull --all)' ';'" % pgkit_spec+"/Specs"
