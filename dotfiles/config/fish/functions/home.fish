# Defined in - @ line 1
function home --wraps='cd ~' --description 'alias home cd ~'
  cd ~ $argv;
end
