# Defined in - @ line 1
function volumedown --wraps='amixer -c 0 set PCM 5%-' --description 'alias volumedown amixer -c 0 set PCM 5%-'
  amixer -c 0 set PCM 5%- $argv;
end
