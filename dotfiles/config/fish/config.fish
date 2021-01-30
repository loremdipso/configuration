set -e fish_user_paths
set -Ua fish_user_paths ~/.local/bin $HOME/.bin $HOME/.gem/ruby/2.7.0/bin $HOME/.cargo/bin $HOME/

#set -x JAVA_HOME /usr/lib/jvm/default/bin/java
#set -x IDEA_JDK /usr/lib/jvm/default/bin/java

#set -x JAVA_HOME /usr/lib/jvm/java-11-openjdk/bin/java
#set -x IDEA_JDK /usr/lib/jvm/java-11-openjdk/bin/java

# Try to use the same cache for rust projects
set -x CARGO_TARGET_DIR $HOME/.cargo-target

if test -f /home/madams/.autojump/share/autojump/autojump.fish
	. /home/madams/.autojump/share/autojump/autojump.fish
end

if status is-interactive
and not set -q TMUX
	exec tmux
end
