ln -s $( dirname -- "$( readlink -f -- "$0"; )"; )/dotfiles ~/.dotfiles
ln -s $( dirname -- "$( readlink -f -- "$0"; )"; )/dotfiles/.wallpaper ~/.wallpaper
sudo nixos-rebuild switch --flake $( dirname -- "$( readlink -f -- "$0"; )"; )/flake#$1
