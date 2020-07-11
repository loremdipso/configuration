set -Ua fish_user_paths ~/.local/bin $HOME/.bin $HOME/.gem/ruby/2.7.0/bin $HOME/.cargo/bin

if status is-interactive
and not set -q TMUX
	exec tmux
end
