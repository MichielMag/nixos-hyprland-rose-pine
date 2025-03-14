#!/usr/bin/env bash

# This script will randomly go through the files of a directory, setting it
# up as the wallpaper at regular intervals
#
# NOTE: this script is in bash (not posix shell), because the RANDOM variable
# we use is not defined in posix

if [[ $# -lt 1 ]] || [[ ! -d $1   ]]; then
	echo "Usage:
	$0 <dir containing images>"
	exit 1
fi

# This controls (in seconds) when to switch to the next image
INTERVAL=300

RANDOMFILE=$(ls $1 | shuf -n 1)
swww img "$1/$RANDOMFILE" --transition-type random
ln -sf "$1/$RANDOMFILE" ~/.wallpaper/.hyprlock