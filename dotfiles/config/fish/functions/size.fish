# Defined in - @ line 1
function size --wraps='du -h' --description 'alias size du -h'
  du -h $argv;
end
