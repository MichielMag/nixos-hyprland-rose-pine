#!/bin/bash
# Default parameters
DEFAULT_PATH="$HOME/.config/Code/User/workspaceStorage"
DEFAULT_AMOUNT=10
DEFAULT_DMENU_CMD="rofi -dmenu -i -p 'Select recent' -config $HOME/.config/rofi/vscode.rasi"

DMENU="${DMENU_CMD:-$DEFAULT_DMENU_CMD}"

# Get parameters with defaults
workspace_path="${1:-$DEFAULT_PATH}"
amount="${2:-$DEFAULT_AMOUNT}"
processed=0

# Check if the path exists
if [ ! -d "$workspace_path" ]; then
    echo "Error: Directory $workspace_path does not exist"
    exit 1
fi

# Declare arrays for names and folders
declare -a names
declare -a folders

# Function to extract and normalize folder name from URI
extract_folder_name() {
    local uri="$1"
    # Remove any protocol prefix (file://, remote://, etc.)
    local path=$(echo "$uri" | sed 's|^[^:]*://||')
    # Replace $HOME with ~
    echo "$path" | sed "s|$HOME|~|g"
}

# Get directories sorted by modification time (newest first)
while IFS= read -r dir; do
    workspace_file="$dir/workspace.json"
    
    # Check if workspace.json exists
    if [ -f "$workspace_file" ]; then
        # Extract the folder property
        folder_value=$(jq -r '.folder // empty' "$workspace_file")
        
        if [ ! -z "$folder_value" ] && [[ ! $folder_value == *"vscode-remote"* ]]; then
            folder_name=$(extract_folder_name "$folder_value")
            
            # Add to arrays
            names+=("$folder_name")
            folders+=("$folder_value")
            
            processed=$((processed + 1))
            if [ $processed -eq $amount ]; then
                break
            fi
        fi
    fi
done < <(find "$workspace_path" -maxdepth 1 -type d -not -name "." -printf "%T@ %p\n" | sort -nr | cut -d' ' -f2-)

# Create selection menu with rofi
selected_name=$(printf '%s\n' "${names[@]}" | $DMENU)

# If user selected something, find matching folder and open VSCode
if [ ! -z "$selected_name" ]; then
    for i in "${!names[@]}"; do
        if [ "${names[$i]}" = "$selected_name" ]; then
            selected_folder="${folders[$i]}"
            # Remove any protocol prefix for VSCode
            clean_folder=$(echo "$selected_folder" | sed 's|^[^:]*://||')
            direnv-code-external "$clean_folder"
            break
        fi
    done
fi