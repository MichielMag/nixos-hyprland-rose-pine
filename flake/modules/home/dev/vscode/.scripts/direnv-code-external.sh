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
if [ -f "$MAPPING_FILE" ]; then
    while IFS=':' read -r path name; do
        # Skip empty lines and comments
        [[ -z "$path" || "$path" =~ ^[[:space:]]*# ]] && continue

        # Remove carriage returns and leading/trailing whitespace
        path=$(echo "$path" | tr -d '\r' | xargs)
        name=$(echo "$name" | tr -d '\r' | xargs)

        # Only process if both path and name are non-empty
        [ -z "$path" ] && continue
        [ -z "$name" ] && continue

        # Normalize paths: use realpath if exists, else strip trailing slashes
        if [ -e "$path" ]; then
            normalized_path=$(realpath "$path")
        else
            normalized_path=$(echo "$path" | sed 's:/*$::')
        fi
        if [ -e "$TARGET_DIR" ]; then
            normalized_target=$(realpath "$TARGET_DIR")
        else
            normalized_target=$(echo "$TARGET_DIR" | sed 's:/*$::')
        fi

        # Remove trailing slashes for comparison (redundant, but safe)
        normalized_path=${normalized_path%/}
        normalized_target=${normalized_target%/}

        # Debug output
        echo "DEBUG: path='$path' name='$name' normalized_path='$normalized_path' normalized_target='$normalized_target'" >&2

        # Check if the path matches our target directory
        if [ "$normalized_path" = "$normalized_target" ]; then
            echo "DEBUG: MATCH FOUND!" >&2
            MAPPED_NAME="$name"
            break
        fi
    done < "$MAPPING_FILE"
fi

# If we found a mapping, check if the mapped folder exists
if [ -n "$MAPPED_NAME" ]; then
    MAPPED_FOLDER="$DIRENV_DIR/$MAPPED_NAME"
    if [ -d "$MAPPED_FOLDER" ]; then
        direnv exec "$MAPPED_FOLDER" code "$TARGET_DIR"
        exit 0
    fi
fi

# Warn if no mapping was found
if [ -z "$MAPPED_NAME" ]; then
    echo "Warning: No mapping found for $TARGET_DIR, using default behavior"
fi

# Fallback: use the target directory itself
direnv exec "$TARGET_DIR" code "$TARGET_DIR"
