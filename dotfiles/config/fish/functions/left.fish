# Defined in - @ line 1
function left --wraps='xrandr -o left' --description 'alias left xrandr -o left'
  xrandr -o left $argv;
end
