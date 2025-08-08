#!/bin/bash
# filepath: /home/michiel/nixos-hyprland-rose-pine/flake/modules/home/dev/vscode/.scripts/direnv-external.sh

# Check if directory parameter is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

TARGET_DIR="$1"
DIRENV_DIR="$HOME/.direnv"
MAPPING_FILE="$DIRENV_DIR/folder-mapping.ini"

# Check if .direnv folder exists
if [ ! -d "$DIRENV_DIR" ]; then
    echo "Error: $DIRENV_DIR folder does not exist"
    exit 1
fi

# Check if mapping file exists
if [ ! -f "$MAPPING_FILE" ]; then
    echo "Warning: $MAPPING_FILE does not exist, using default behavior"
    direnv exec "$TARGET_DIR" code "$TARGET_DIR"
    exit 0
fi

# Parse the mapping file to find the target directory
MAPPED_NAME=""
while IFS=':' read -r path name; do
    # Skip empty lines and comments
    [[ -z "$path" || "$path" =~ ^[[:space:]]*# ]] && continue
    
    # Remove leading/trailing whitespace
    path=$(echo "$path" | xargs)
    name=$(echo "$name" | xargs)
    
    # Check if the path matches our target directory
    if [ "$path" = "$TARGET_DIR" ]; then
        MAPPED_NAME="$name"
        break
    fi
done < "$MAPPING_FILE"

# If we found a mapping, check if the mapped folder exists
if [ -n "$MAPPED_NAME" ]; then
    MAPPED_FOLDER="$DIRENV_DIR/$MAPPED_NAME"
    if [ -d "$MAPPED_FOLDER" ]; then
        echo "Found mapping: $TARGET_DIR -> $MAPPED_NAME"
        direnv exec "$MAPPED_FOLDER" code "$TARGET_DIR"
    else
        echo "Warning: Mapped folder $MAPPED_FOLDER does not exist, using default behavior"
        direnv exec "$TARGET_DIR" code "$TARGET_DIR"
    fi
else
    echo "No mapping found for $TARGET_DIR, using default behavior"
    direnv exec "$TARGET_DIR" code "$TARGET_DIR"
fi