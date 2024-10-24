#!/bin/bash

# Execute hyprctl activewindow and capture its output
window_info=$(hyprctl activewindow)

# Extract the value after "initialClass:" and remove any newline characters
window_class=$(echo "$window_info" | grep "initialClass:" | awk -F': ' '{print $2}' | tr -d '\n')

# Echo the extracted value
echo "$window_class"