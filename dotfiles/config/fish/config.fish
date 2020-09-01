set -e fish_user_paths
set -Ua fish_user_paths ~/.local/bin $HOME/.bin $HOME/.gem/ruby/2.7.0/bin $HOME/.cargo/bin

if test -f /home/madams/.autojump/share/autojump/autojump.fish
	. /home/madams/.autojump/share/autojump/autojump.fish
end

if status is-interactive
and not set -q TMUX
	exec tmux
end
