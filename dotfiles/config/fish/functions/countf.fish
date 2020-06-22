# Defined in - @ line 1
function countf --wraps='echo *.* | wc -w' --description 'alias countf echo *.* | wc -w'
  echo *.* | wc -w $argv;
end
