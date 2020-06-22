# Defined in - @ line 1
function volumeup --wraps='amixer -c 0 set PCM 5%+' --description 'alias volumeup amixer -c 0 set PCM 5%+'
  amixer -c 0 set PCM 5%+ $argv;
end
