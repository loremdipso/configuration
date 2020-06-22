# Defined in - @ line 1
function normal --wraps='xrandr -o normal' --description 'alias normal xrandr -o normal'
  xrandr -o normal $argv;
end
