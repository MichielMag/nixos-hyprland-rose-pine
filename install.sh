DOTFILES=$( dirname -- "$( readlink -f -- "$0"; )"; )/home/.dotfiles
WALLPAPER=$( dirname -- "$( readlink -f -- "$0"; )"; )/home/.wallpaper

DOTFILES_HOME=~/.dotfiles
WALLPAPER_HOME=~/.wallpaper

if [[ -d "$DOTFILES_HOME" ]]; then
    echo "dotfiles symlink already exists, skipping"
else
    echo "Linking dotfiles"
    ln -s "$DOTFILES" "$DOTFILES_HOME"
fi

if [[ -d "$WALLPAPER_HOME" ]]; then
    echo "wallpaper symlink already exists, skipping"
else
    echo "Linking wallpaper"
    ln -s "$WALLPAPER" "$WALLPAPER_HOME"
fi

sudo nixos-rebuild switch --flake $( dirname -- "$( readlink -f -- "$0"; )"; )/flake#$1
