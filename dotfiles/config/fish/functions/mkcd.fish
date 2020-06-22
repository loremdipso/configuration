function mkcd --description "Makes and then cd's into a directory"
	command mkdir $argv ;and builtin cd $argv;
end
