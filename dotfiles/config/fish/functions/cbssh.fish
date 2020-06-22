# Defined in - @ line 1
function cbssh --wraps='cb ~/.ssh/id_rsa.pub' --description 'alias cbssh cb ~/.ssh/id_rsa.pub'
  cb ~/.ssh/id_rsa.pub $argv;
end
