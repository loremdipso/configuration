# Defined in - @ line 1
function countl --wraps='wc -l' --description 'alias countl wc -l'
  wc -l $argv;
end
