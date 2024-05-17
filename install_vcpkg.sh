#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define the vcpkg directory
VCPKG_DIR="$(pwd)/vcpkg"
VCPKG_REPO="https://github.com/microsoft/vcpkg"
VCPKG_BRANCH="master"

# Check if vcpkg directory exists, if not clone it
if [ ! -d "$VCPKG_DIR" ]; then
    echo "Cloning vcpkg..."
    git clone "$VCPKG_REPO" "$VCPKG_DIR"
fi

# Change to the vcpkg directory
cd "$VCPKG_DIR"

# Check out the specified branch
echo "Checking out vcpkg branch..."
git checkout "$VCPKG_BRANCH"

# Bootstrap vcpkg
echo "Bootstrapping vcpkg..."
./bootstrap-vcpkg.sh

# Install dependencies
echo "Installing dependencies..."
./vcpkg install

# Change back to the original directory
cd -

echo "vcpkg installation and dependency installation complete."
