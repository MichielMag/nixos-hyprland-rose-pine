#!/bin/bash

# Split XDG_DATA_DIRS by ':' and iterate through each directory
IFS=':' read -ra DIRS <<< "$XDG_DATA_DIRS"
for dir in "${DIRS[@]}"; do
  app_dir="${dir}/applications"
  if [ -d "$app_dir" ]; then
    find "$app_dir" -name "*.desktop" -print
  fi
done