
function sudo --description "Replacement for Bash 'sudo !!' command to run last command using sudo."
	if test "$argv" = !!
		#eval command sudo $history[1]
		commandline "sudo $history[1]"
		# history delete --prefix "sudo !!"
		commandline -f execute
	else
		command sudo $argv
	end
end

