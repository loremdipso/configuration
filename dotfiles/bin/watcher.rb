#!/usr/bin/ruby
require 'getoptlong'

def main(args)
	custom_exe = nil
	opts = GetoptLong.new(
		  [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
		  [ '--custom', GetoptLong::NO_ARGUMENT ],
	)

	custom = false
	opts.each do |opt, arg|
		case opt
		when '--help'
			puts "--help"
			puts "--custom"
			return
		when '--custom'
			custom = true
			args.delete(opt)
		end
	end

	arg_string = args.map{|e| '"'+e+'"'}.join(" ")
	to_watch, to_execute = nil, nil
	if File.exists?("Cargo.toml")
		to_watch, to_execute = rust(arg_string)
	elsif File.exists?("go.mod")
		if File.exists?("cmd")
			to_watch, to_execute = "./cmd", "go run ./cmd/main.go"
		else
			to_watch, to_execute = "./src", "go run ."
		end
	elsif File.exists?("src/go.mod")
		to_watch, to_execute = ".", "go run ./src"
	elsif Dir['*.c'].any?
		to_watch, to_execute = "*.c", "gcc *.c && ./a.out"
	elsif File.exists?("package.json")
		to_watch, to_execute = "*.* ./src", "npm run build"
	elsif File.exists?("package.json")
		to_watch, to_execute = "*.* ./src", "npm run build"
	elsif Dir['*.py'].any?
		to_watch = "*.py *.txt"
		to_execute = "./#{Dir['*.py'].first}"
	else
		puts "ERROR: dunno what to do"
		return
	end

	to_execute = arg_string if custom

	doit(to_watch, "printf \"\ec\" && #{to_execute}")

	puts "Error, kid"
end

def rust(arguments)
	# we're a rust project, so watch those files
	if File.exists?("./src/main.rs")
		return ["./src ./Cargo.toml", "RUST_LOG=info && cargo run -q -- #{arguments}"]
	elsif File.exists?("./src/lib.rs")
		return ["./src ./Cargo.toml", "cargo build -- #{arguments}"]
	end
end


def doit(to_watch, to_execute)
	exec("#{to_execute} ; filewatcher #{to_watch} \"#{to_execute}\"")
end

main(ARGV.dup)
