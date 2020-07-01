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
            :dry_run => false,
            :force => false,
            :skip => false
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
	end


    @@options.push(Arg.new(:dry_run, "Dry run", "--dryrun", "--dry"))
    def dry_run()
        @flags[:dry_run] = true
    end

    @@options.push(Arg.new(:skip, "Skip if the local file is newer", "--skip"))
    def skip()
        @flags[:skip] = true
    end

    @@options.push(Arg.new(:force, "Overrite local file even if they're newer", "--force"))
    def force()
        @flags[:force] = true
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
		#seen_dirs = []

		paths.sort.each do |f|
            if File.directory?(f)
                if has_files(f)
                    dirs.push(f)
                end
            else
                files.push(f)
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

		#if Dir.exists?(local)
			#puts "\tRemoving #{local}..."
			#`rm -rf "#{local}"`
		#end

        puts "\Ensuring this path exists: #{local}..."
        if @flags[:dry_run]
            puts "\t\t<not really>"
        else
            FileUtils.mkdir_p(local)
        end
	end

    def Manager.get_files()
        # NOTE: assumes we're in dotfiles
        Manager.filter_paths(Dir['./**/*'])
    end

    def ensure_file(filename)
        puts "\n\n\n"
        local = Manager.localize(filename)
        if File.exists?(local)
            # TODO: check mtimes
            if File.mtime(local) > File.mtime(filename)
                if @flags[:force]
                    # do nothing, always process file
                elsif @flags[:skip]
                    puts "Whoa! Local file (#{local}) is newer. Skipping."
                else
                    puts "Local file (#{local}) is newer. Copy anyway? (y/n)> ."
                    answer = STDIN.gets().chomp.downcase
                    return if answer[0] != 'y'
                end
            end

            print "Overriding #{local} with #{filename}..."
        else
            print "Copying #{filename} to #{local}..."
        end

        if @flags[:dry_run]
            puts "<not really>"
        else
            FileUtils.cp(filename, local)
            puts "done"
        end
	end
end


if __FILE__ == $0
	Manager.new(ARGV.dup)
end

