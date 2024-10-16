#!/bin/bash

# Define the search string if provided
search_string="$1"

# Split XDG_DATA_DIRS by ':' and iterate through each directory
IFS=':' read -ra DIRS <<< "$XDG_DATA_DIRS"
for dir in "${DIRS[@]}"; do
  app_dir="${dir}/applications"
  if [ -d "$app_dir" ]; then
    if [ -z "$search_string" ]; then
      # No search string provided, list all .desktop files
      find "$app_dir" -name "*.desktop" -print
    else
      # Search string provided, filter .desktop files
      find "$app_dir" -name "*.desktop" -print | grep -i "$search_string"
    fi
  fi
done