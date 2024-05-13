cmake_minimum_required(VERSION 3.14)

project(RT3DGE_Encoding LANGUAGES CXX)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Use vcpkg for dependency management
if(NOT DEFINED CMAKE_TOOLCHAIN_FILE)
    set(CMAKE_TOOLCHAIN_FILE "${CMAKE_CURRENT_SOURCE_DIR}/vcpkg/scripts/buildsystems/vcpkg.cmake"
        CACHE STRING "Vcpkg toolchain file")
endif()

# Find dependencies
find_package(nlohmann_json CONFIG REQUIRED)
find_package(OpenSSL REQUIRED)

# Include directories
include_directories(${PROJECT_SOURCE_DIR}/include)

# Source files
file(GLOB_RECURSE SOURCES ${PROJECT_SOURCE_DIR}/src/*.cpp)

# Add library
add_library(${PROJECT_NAME} SHARED ${SOURCES})

# Link dependencies
target_link_libraries(${PROJECT_NAME} PRIVATE nlohmann_json::nlohmann_json OpenSSL::SSL OpenSSL::Crypto)

# Specify DLL export
target_compile_definitions(${PROJECT_NAME} PRIVATE RT3DGE_Encoding_EXPORTS)

# Installation
install(TARGETS ${PROJECT_NAME} DESTINATION lib)
install(FILES include/RT3DGE_Encoding.h DESTINATION include)
