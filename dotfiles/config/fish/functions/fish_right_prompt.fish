function fish_right_prompt
    set_color $fish_color_user
	pwd | sed "s|^$HOME|~|"
end
