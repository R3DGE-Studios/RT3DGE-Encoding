#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define source and destination directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/build/Debug"
DEST_DIR="$SCRIPT_DIR/release"
ZIP_FILE="$SCRIPT_DIR/compressed"

# Create the destination directory if it doesn't exist
if [ ! -d "$DEST_DIR" ]; then
    mkdir -p "$DEST_DIR"
else
    rm -rf "$DEST_DIR"
    mkdir -p "$DEST_DIR"
fi

# Copy the required files from source to destination
cp "$SOURCE_DIR/RT3DGE_Encoding.lib" "$DEST_DIR/"
cp "$SOURCE_DIR/RT3DGE_Encoding.dll" "$DEST_DIR/"

# Get the current timestamp in the format YYYYMMDD-HHMMSS
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")

# Check if zip is available
if ! command -v zip &> /dev/null
then
    echo "zip command could not be found. Please install zip."
    exit 1
fi

# Create a zip file of the destination directory
mkdir -p "$ZIP_FILE"
zip -r "$ZIP_FILE/release-$TIMESTAMP.zip" "$DEST_DIR"/*

# Check if the zip file was created successfully
if [ -f "$ZIP_FILE/release-$TIMESTAMP.zip" ]; then
    echo "The files were successfully copied and zipped."
else
    echo "There was an error creating the zip file."
    exit 1
fi

echo "Script completed successfully."
read -p "Press any key to continue..."
exit 0
