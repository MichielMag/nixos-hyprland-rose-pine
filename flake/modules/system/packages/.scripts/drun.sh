#!/bin/bash

# Check if an argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <application_name>"
  exit 1
fi

# Define variables
name="$1"
entry_to_run="${name}.desktop"

# Split XDG_DATA_DIRS by ':' and iterate through each directory
IFS=':' read -ra DIRS <<< "$XDG_DATA_DIRS"
for dir in "${DIRS[@]}"; do
  app_dir="${dir}/applications"
  if [ -d "$app_dir" ]; then
    entry_path="${app_dir}/${entry_to_run}"
    if [ -f "$entry_path" ]; then
      dex "$entry_path"
      exit 0
    fi
  fi
done

# If the entry was not found, send a notification
notify-send --urgency=warning "Could not find application ${name}"