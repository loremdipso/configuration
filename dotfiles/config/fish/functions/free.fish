# Defined in - @ line 1
function free --wraps='free -m' --description 'alias free free -m'
 command free -m $argv;
end
