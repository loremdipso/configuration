# Defined in - @ line 1
function aliases --wraps='compgen -a' --description 'alias aliases compgen -a'
  compgen -a $argv;
end
