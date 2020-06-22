# Defined in - @ line 1
function ifconfig --wraps='ip addr' --description 'alias ifconfig ip addr'
  ip addr $argv;
end
