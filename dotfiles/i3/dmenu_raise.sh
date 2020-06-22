#!/bin/sh
# TODO: use i3-dmenu-desktop instead of dmenu_path

CMD=$(dmenu_path | dmenu)

# if no instance of the app has been started, launch one now
if [ `ps -aux | grep -i "$CMD" | wc | awk '{print $1}'` -le 1 ]; then
	"$CMD" &
else
	i3-msg "[class=\"(?i)$CMD\"] focus"
fi

