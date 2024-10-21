function gitid --description 'git identify'
    eval (ssh-agent -c)
    ssh-add ~/.ssh/github_ed25519        
end
