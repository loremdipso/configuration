#!/usr/bin/env ruby
require 'fileutils'

def main(args)
	Dir.chdir("./dotfiles") do
		dirs, files = filter(Dir['./**/*'])
		dirs.each { |f| ensure_directory(f) }
		files.each { |f| ensure_file(f) }
	end
end

def filter(paths)
	dirs = []
	files = []
	seen_dirs = []

	paths.sort.each do |f|
		if seen_dirs.all?{|s| f.index(s) == nil}
			if File.directory?(f)
				if has_files(f)
					seen_dirs.push(f)
					dirs.push(f)
				end
			else
				files.push(f)
			end
		end
	end

	[dirs, files]
end

def has_files(path)
	Dir[File.join(path, "*")].any? do |f|
		File.exists?(f) and not Dir.exists?(f)
	end
end


def localize(name)
	name.sub(/^\.\//, "#{File.expand_path("~")}/.")
end


def ensure_directory(dirname)
	local = localize(dirname)
	puts "\nMaking #{local}..."

	if Dir.exists?(local)
		puts "\tRemoving #{local}..."
		`rm -rf "#{local}"`
	end

	puts "\tRecursively copying #{dirname} over to #{local}..."
	`cp -r "#{dirname}" "#{local}"`
end


def ensure_file(filename)
	local = localize(filename)
	puts "Overriding #{local} with #{filename}..."
	FileUtils.cp(filename, local)
end


main(ARGV.dup)

