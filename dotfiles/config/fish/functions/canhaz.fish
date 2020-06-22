# Defined in - @ line 1
function canhaz --wraps='sudo apt-get install' --description 'alias canhaz sudo apt-get install'
  sudo apt-get install $argv;
end
