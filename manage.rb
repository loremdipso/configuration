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

    def keys
        return ([@symbol.to_s] + @synonyms).join(" | ")
    end

    def description
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
            :verbose => false,
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

    @@options.push(Arg.new(:verbose, "Talkative", "--verbose"))
    def verbose()
        @flags[:verbose] = true
    end

    @@options.push(Arg.new(:skip, "Skip if the target file is newer", "--skip"))
    def skip()
        @flags[:skip] = true
    end

    @@options.push(Arg.new(:force, "Overrite target file even if they're newer", "--force"))
    def force()
        @flags[:force] = true
    end

    @@options.push(Arg.new(:help, "Get help", "--help"))
    def help()
        puts "Options:"
        @@options.each do |opt|
            puts "\t#{opt.keys}:"
            puts "\t\t#{opt.description}"
            puts ""
        end

        puts "Actions:"
        @@actions.each do |act|
            puts "\t#{act.keys}:"
            puts "\t\t#{act.description}"
            puts ""
        end
        exit(0)
	end

    @@actions.push(Arg.new(:pull, "Pull config files into here"))
	def pull()
        Dir.chdir("./dotfiles") do
            _, files = Manager.get_files()
            files.each { |f| safe_move_file(Manager.localize(f), f) }
        end
	end

    @@actions.push(Arg.new(:push, "Push config files out"))
	def push()
        Dir.chdir("./dotfiles") do
            dirs, files = Manager.get_files()
            dirs.each { |d| ensure_local_directory(d) }
            files.each { |f| safe_move_file(f, Manager.localize(f)) }
        end
	end


	def self.filter_paths(paths)
		dirs = []
		files = []

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

	def ensure_local_directory(dirname)
		local = Manager.localize(dirname)

        if File.exists?(local)
            return
        end

        puts "\Ensuring this path exists: #{local}..."
        if @flags[:dry_run]
            puts "\t\t<not really>"
        else
            FileUtils.mkdir_p(local)
        end
	end

    def self.get_files()
        # NOTE: assumes we're in dotfiles
        self.filter_paths(Dir['./**/*'])
    end

    def safe_move_file(source, target)
		if not File.exists?(source)
			puts "#{source} doesn't exist. Removing local."
			if @flags[:skip]
				puts "Not really"
			else
				File.delete(target)
			end

			return
		end

		if File.exists?(target)
            if File.read(source) == File.read(target)
                puts "Same. Skipping #{target}" if @flags[:verbose]
                return
            elsif File.mtime(target).to_i - File.mtime(source).to_i > 10 # 10ms
                if @flags[:force]
                    # do nothing, always process file
                elsif @flags[:skip]
                    print "Whoa! target file (#{target}) is newer. Skipping."
                else
                    print "target file (#{target}) is newer. Copy anyway (y/n)?: "
                    answer = STDIN.gets().chomp.downcase
                    return if answer[0] != 'y'
                end
            end

            print "Overriding #{target}: "
        else
            print "Copying into #{target}: "
        end

        if @flags[:dry_run]
            puts "<not really>"
        else
            FileUtils.cp(source, target, preserve: true)
            puts "done"
        end
	end
end


if __FILE__ == $0
	Manager.new(ARGV.dup)
end

