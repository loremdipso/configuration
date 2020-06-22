# Defined in - @ line 1
function cbhs --wraps='cat | tail -n 1 | cb' --description 'alias cbhs cat  | tail -n 1 | cb'
  cat | tail -n 1 | cb $argv;
end
