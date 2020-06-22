function lcd --description "CD's and then ls's into a dir. Prolly can't replace vanilla cd because it'd ruin history, or something"
	builtin cd $argv ;and ls
end
