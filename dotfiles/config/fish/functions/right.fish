# Defined in - @ line 1
function right --wraps='xrandr -o right' --description 'alias right xrandr -o right'
  xrandr -o right $argv;
end
