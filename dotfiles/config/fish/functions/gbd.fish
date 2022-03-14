# Stands for "git - but I'm a Bad Developer"
function gbd --description "git add . && git commit -m 'message' && git push"
	git add .
	git status

	if count $argv > /dev/null
		git commit -m "$argv"
		git push
	else
		echo "need a commit message, y'all"
	end
end

