#!/usr/bin/env ruby
# GOAL: be very portable. Don't want to install a tonne of gems at fist go
# GOAL: be simple
# GOAL: make sense
require 'fileutils'

class Arg
    attr_reader :symbol

    def initialize(symbol, description, *synonyms)
        @symbol = symbol
        @description = description
        @synonyms = synonyms
    end

    def matches(str)
        return @symbol.to_s == str || @synonyms.any? {|s| s == str}
    end

    def to_s
        return @description
    end
end


class Manager
    @@options = []
    @@actions = []

    def initialize(args)
        @flags = {
            :dry_run => false
        }

		# operate on options
        args.each do |arg|
            option = @@options.find{|opt| opt.matches(arg) }
            method(option.symbol).call() if option != nil
        end

		# perform actions
        args.each do |arg|
            action = @@actions.find{|opt| opt.matches(arg) }
            method(action.symbol).call() if action != nil
        end

		# 	case arg
		# 	when "--help"
		# 		return help()
		# 	when "--dry"
		# 	when "pull"
		# 		pull(files)
		# 	end
		# end


		# args.each do |arg|
		# 	case arg
		# 	when "pull"
		# 		pull(files)
		# 	when "push"
		# 		push(dirs, files)
		# 	end
		# end
	end


    @@options.push(Arg.new(:dry_run, "Dry run", "--dryrun", "--dry"))
    def dry_run()
        @flags[:dry_run] = true
    end

    @@options.push(Arg.new(:help, "Get help", "--help"))
    def help()
        puts "Options:"
        @@options.each do |opt|
            puts "\t#{opt}"
        end

        puts "Actions:"
        @@actions.each do |act|
            puts "\t#{act}"
        end
	end

    @@actions.push(Arg.new(:pull, "Pull config files into here"))
	def pull()
        Dir.chdir("./dotfiles") do
            _, files = get_files()
            # TODO
        end
	end

    @@actions.push(Arg.new(:push, "Push config files out"))
	def push()
        Dir.chdir("./dotfiles") do
            dirs, files = Manager.get_files()

            dirs.each { |f| ensure_directory(f) }
            files.each { |f| ensure_file(f) }
        end
	end


	def self.filter_paths(paths)
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

	def self.has_files(path)
		Dir[File.join(path, "*")].any? do |f|
			File.exists?(f) and not Dir.exists?(f)
		end
	end


	def Manager.localize(name)
		name.sub(/^\.\//, "#{File.expand_path("~")}/.")
	end

	def ensure_directory(dirname)
		local = Manager.localize(dirname)
		puts "\nMaking #{local}..."

		if Dir.exists?(local)
			puts "\tRemoving #{local}..."
			`rm -rf "#{local}"`
		end

        puts "\tRecursively copying #{dirname} over to #{local}..."
        if @flags[:dry_run]
            puts "\t\t<not really>"
        else
            FileUtils.cp_r(dirname, local)
        end
	end

    def Manager.get_files()
        # NOTE: assumes we're in dotfiles
        Manager.filter_paths(Dir['./**/*'])
    end

	def ensure_file(filename)
		local = Manager.localize(filename)
        puts "Overriding #{local} with #{filename}..."
        if @flags[:dry_run]
            puts "<not really>"
        else
            FileUtils.cp(filename, local)
        end
	end
end


if __FILE__ == $0
	Manager.new(ARGV.dup)
end

