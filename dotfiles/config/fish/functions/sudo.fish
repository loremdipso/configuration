
function sudo --description "Replacement for Bash 'sudo !!' command to run last command using sudo."
	if test "$argv" = !!
		#eval command sudo $history[1]
		# This version will replace the history, so that's cool
		commandline "sudo $history[1]"
		history delete --exact --case-sensitive 'sudo !!'
		commandline -f execute
	else
		command sudo $argv
	end
end

