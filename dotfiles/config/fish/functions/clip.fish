# Defined in - @ line 1
function clip --wraps='xclip -selection clipboard -i' --description 'alias clip xclip -selection clipboard -i'
  xclip -selection clipboard -i $argv;
end
