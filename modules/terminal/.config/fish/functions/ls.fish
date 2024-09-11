# Defined via `source`
function ls --wraps='eza -al --color=always --group-directories-first --icons' --description 'alias ls=eza -al --color=always --group-directories-first --icons'
  eza -al --color=always --group-directories-first --icons --git --header=always $argv
end