function ls --wraps='eza -al --color=always --group-directories-first --icons --git --header' --description 'alias ls=eza -al --color=always --group-directories-first --icons --git --header'
  eza -al --color=always --group-directories-first --icons --git --header $argv
        
end