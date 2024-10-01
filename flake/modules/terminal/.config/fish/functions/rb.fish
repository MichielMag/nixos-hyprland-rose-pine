function rb --wraps='sudo nixos-rebuild switch --flake .#quickemu --fast' --description 'alias rb sudo nixos-rebuild switch --flake .#quickemu --fast'
  sudo nixos-rebuild switch --flake .#quickemu --fast $argv
        
end
