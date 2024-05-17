#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define the CMake version to install
CMAKE_VERSION="3.25.0"
CMAKE_ZIP="cmake-$CMAKE_VERSION-linux-x86_64.tar.gz"
CMAKE_DIR="cmake-$CMAKE_VERSION-linux-x86_64"

# Define the URL to download CMake
CMAKE_URL="https://github.com/Kitware/CMake/releases/download/v$CMAKE_VERSION/$CMAKE_ZIP"

# Define the local directory to install CMake
INSTALL_DIR="$(pwd)/cmake"

# Create the installation directory if it doesn't exist
if [ ! -d "$INSTALL_DIR" ]; then
    mkdir -p "$INSTALL_DIR"
fi

# Change to the installation directory
pushd "$INSTALL_DIR"

# Download CMake if it hasn't been downloaded already
if [ ! -f "$CMAKE_ZIP" ]; then
    echo "Downloading CMake $CMAKE_VERSION..."
    wget "$CMAKE_URL"
fi

# Unzip CMake if it hasn't been unzipped already
if [ ! -d "$CMAKE_DIR" ]; then
    echo "Extracting CMake..."
    tar -xzf "$CMAKE_ZIP"
fi

# Add CMake bin directory to PATH
CMAKE_BIN="$INSTALL_DIR/$CMAKE_DIR/bin"
export PATH="$CMAKE_BIN:$PATH"

# Verify the installation by checking the CMake version
echo "Verifying CMake installation..."
cmake --version

# Cleanup
popd

echo "CMake installation completed successfully."
