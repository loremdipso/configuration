# i3materials

Not all of this is my dev (I've tried to keep the files as they were, including their original headers with Author accreditations and LICENSE info), and none of this is polished yet. workspace_utils is just a wrapper around the i3 python module, and it's arguably the most useful part of this whole repo. It lets you:

	- Move a workspace to
		- the next/previous monitor
		- the next/previous workspace position
		- the workspace before/after the current smallest/largest workspace (assumes all workspaces are numerical; ignore those that aren't)
	- Move a window to
		- the next/previous monitor
		- the next/previous workspace
		- the workspace before/after the current smallest/largest workspace (assumes all workspaces are numerical; ignore those that aren't)

