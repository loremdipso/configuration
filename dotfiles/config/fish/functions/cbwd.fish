# Defined in - @ line 1
function cbwd --wraps='pwd | cb' --description 'alias cbwd pwd | cb'
  pwd | cb $argv;
end
