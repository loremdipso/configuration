# Defined in - @ line 1
function np --wraps='nano -w PKGBUILD' --description 'alias np nano -w PKGBUILD'
  nano -w PKGBUILD $argv;
end
