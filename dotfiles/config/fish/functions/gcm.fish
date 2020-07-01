function gcm --description "git commit -m"
	if count $argv > /dev/null
		git commit -m "$argv"
	else
		echo "need a commit message, y'all"
	end
end

