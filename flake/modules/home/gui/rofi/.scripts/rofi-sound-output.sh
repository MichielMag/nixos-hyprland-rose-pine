#!/usr/bin/env bash

# Check if the argument is provided

if [ -z "$1" ]; then
echo "Usage: $0 <sink|source>"
exit 1
fi

setting=$1

# Validate the argument

if [[ "$setting" != "sink" && "$setting" != "source" ]]; then
	echo "Invalid argument: $setting. Use 'sink' or 'source'."
	exit 1
fi

# Get the wpctl status output

status=$(wpctl status)

# Extract the relevant section

# Extract the section between 'Audio' and 'Video'
audio_section=$(echo "$status" | awk '/Audio/,/Video/')

# Extract the relevant section based on the setting
if [ "$setting" == "sink" ]; then
	section=$(echo "$audio_section" | awk '/Sinks:/,/Sources:/')
else
	section=$(echo "$audio_section" | awk '/Sources:/,/Filters:/')
fi



# Parse the section and generate options for rofi

options=$(echo "$section" | grep -E '^\s*│' | while read -r line; do
echo "$line"
	id=$(echo "$line" | awk '{print $2}')
	name=$(echo "$line" | sed -E 's/^\s*│\s*\*?\s*[0-9]+\. (._) \[vol:._/\1/')
	state=$(echo "$line" | grep -q '\*' && echo '󰱒' || echo '󰄱')
	type=$(echo "$name" | awk '{print tolower($0)}' | grep -q 'headset' && echo '󰋎' || \
         echo "$name" | awk '{print tolower($0)}' | grep -q 'headphone' && echo '󰋋' || \
         echo "$name" | awk '{print tolower($0)}' | grep -q 'webcam' && echo '󰖠' || \
         echo "$name" | awk '{print tolower($0)}' | grep -q 'microphone' && echo '󰍬' || \
         echo "$name" | awk '{print tolower($0)}' | grep -q 'hdmi' && echo '󰽟' || \
         echo "$name" | awk '{print tolower($0)}' | grep -q 'displayport' && echo '󰽟' || \
         echo '󰓃')
  echo "$state\t$type $name"
done)

# Call rofi with the options

DEFAULT_DMENU_CMD="rofi -dmenu -i -p 'Select audiodevice' -config $HOME/.config/rofi/audio.rasi"
DMENU="${DMENU_CMD:-$DEFAULT_DMENU_CMD}"
selected=$(echo -e "$options" | $DMENU)

# Extract the id from the selected option

id=$(echo "$selected" | awk '{print $2}')

# Set the default device

wpctl set-default "$id"
