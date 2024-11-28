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

declare -A ids=()

options=$(echo "$section" | grep -E '^\s+│\s+' | while read -r line; do
	id=$(echo "$line" | awk '{print $2}')
	star=$(echo "$line" | grep -q '\*' && echo '󰱒' || echo '󰄱')
	if [ "$star" == "󰱒" ]; then
		id=$(echo "$line" | awk '{print $3}')
	fi

	if [ "$id" == "" ]; then
		continue
	fi

	id=$(echo "$id" | sed 's/[^0-9]//g')

	# Split the name on the delimiter ' [vol:'
	name=$(echo "$line" | awk -F '.' '{print $2}' | awk -F '[' '{print $1}')

	# Trim whitespace from the start and end of the name
	name=$(echo "$name" | sed 's/^[ \t]*//;s/[ \t]*$//')

	lowername=$(echo "$name" | awk '{print tolower($0)}')

	isheadphone=$(echo "$lowername" | grep -q 'headphone' && echo 'true' || echo 'false')
	isheadset=$(echo "$lowername" | grep -q 'headset' && echo 'true' || echo 'false')
	iswebcam=$(echo "$lowername" | grep -q 'webcam' && echo 'true' || echo 'false')
	ismicrophone=$(echo "$lowername" | grep -q 'microphone' && echo 'true' || echo 'false')
	ishdmi=$(echo "$lowername" | grep -q 'hdmi' && echo 'true' || echo 'false')
	isdisplayport=$(echo "$lowername" | grep -q 'displayport' && echo 'true' || echo 'false')

	if [ "$isheadphone" == "true" ]; then
		type="󰋋"
	elif [ "$isheadset" == "true" ]; then
		type="󰋎"
	elif [ "$iswebcam" == "true" ]; then
		type="󰖠"
	elif [ "$ismicrophone" == "true" ]; then
		type="󰍬"
	elif [ "$ishdmi" == "true" ]; then
		type="󰽟"
	elif [ "$isdisplayport" == "true" ]; then
		type="󰽟"
	else
		type="󰓃"
	fi

	option=$(echo "$star $id $type $name")

	ids[$option]=$id

	echo "$option"
done)

# Print the ids dictionary
for key in "${!ids[@]}"; do
	echo "$key: ${ids[$key]}"
done

# Call rofi with the options

DEFAULT_DMENU_CMD="rofi -dmenu -i -p 'Select audiodevice' -config $HOME/.config/rofi/audio.rasi"
DMENU="${DMENU_CMD:-$DEFAULT_DMENU_CMD}"

selected=$(echo -e "$options" | $DMENU)

# Extract the id from the selected option

id=$(echo "$selected" | awk '{print $2}')

# Set the default device

wpctl set-default "$id"
