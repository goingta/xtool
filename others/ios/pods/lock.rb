require 'cocoapods-core'
require 'cocoapods'

config = Pod::Config.instance
# puts config.home_dir

#Podfile
# puts config.podfile


# puts config.podfile.target_definitions
# puts config.podfile.target_definition_list

      # keys_hint = [
      #   'PODS',
      #   'DEPENDENCIES',
      #   'EXTERNAL SOURCES',
      #   'SPEC CHECKSUMS',
      #   'COCOAPODS',
      # ]


# puts config.podfile.dependencies
# config.podfile.to_hash["target_definitions"][0].each do |k,v|
# 	puts "k=#{k},v=#{v}"
# end

# File.open("./Podfile", 'w') { |f| f.write(to_yaml) }

# puts config.podfile_path
# config.podfile.write_to_disk(config.podfile_path)
# puts config.lockfile_path
# config.lockfile.write_to_disk(config.lockfile_path)


# File.open("./Podfile") do |fr|
# 	fr.each do |line|

# 		if line.include?("pod ")
# 			string = line
# 			match_data = string.match(%r{^pod +'([a-zA-Z0-9_/\-]+)' *, *'([a-zA-Z0-9_.\-+]+)'})

# 			name = match_data[1]
# 			version = match_data[2]
# 			version = version.gsub(/[()]/,'') if version

# 			case version
# 			when nil, /from `(.*)(`|')/
# 				dependency = Pod::Dependency.new(name)
# 			when /HEAD/
# 				dependency = Pod::Dependency.new(name, :head)
# 			else
# 				puts "11"
# 				version_requirements =  version.split(',') if version
# 				dependency = Pod::Dependency.new(name, version_requirements)
# 			end

# 			# puts dependency.name

# 			# dependency.requirement.requirements.all? do |_operator, version|
#    #      		puts version
#    #      	end
# 		end
# 	end
#     # buffer = fr.read.gsub(/a/, "A")
#     # File.open("new_file.txt", "w") { |fw| fw.write(buffer) }
# end
puts "Source:"
puts config.podfile.sources

puts ""
puts "plugins:"
puts config.podfile.plugins

puts ""
puts "target_definition_list:"
config.podfile.target_definitions.each do |key,value|
	puts value.name
	if value.platform.class != NilClass
		puts value.platform.name
		puts value.platform.deployment_target
	end
	puts value.inhibits_warnings_for_pod("")
	

	puts value.non_inherited_dependencies
	value.dependencies.each do |d|
		puts d
		puts "name:#{d.name}"
		puts "head:#{d.head}"
		puts "requirement:#{d.requirement}"
		puts "source:#{d.external_source}"
		puts
	end

	puts
end


# puts ""
# puts "pods:"
# config.podfile.dependencies.each do |dep|
# 	puts dep.name
# 	puts dep.external_source
# 	puts dep.head
# 	puts dep.specific_version
# end

puts config.podfile.class
# puts config.podfile.to_hash
