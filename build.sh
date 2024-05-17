#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Create the build directory if it doesn't exist
mkdir -p build

# Change to the build directory
cd build

# Run CMake to configure the project
cmake .. -DCMAKE_TOOLCHAIN_FILE=../vcpkg/scripts/buildsystems/vcpkg.cmake

# Build the project
cmake --build .

# Pause execution and wait for user input
read -p "Press any key to continue..."

echo "Build process completed successfully."
