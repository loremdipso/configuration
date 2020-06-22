# Defined in - @ line 1
function say --wraps='echo | espeak -ven+f1' --description 'alias say echo  | espeak -ven+f1'
  echo | espeak -ven+f1 $argv;
end
