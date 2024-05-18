cmake_minimum_required(VERSION 3.14)
project(crashpad-precompiled)

message(STATUS "CMAKE_SYSTEM_PROCESSOR: ${CMAKE_SYSTEM_PROCESSOR}")
if(${CMAKE_SYSTEM_PROCESSOR} STREQUAL "AMD64" AND WIN32)
    message(STATUS "Compiling for Windows x86_64")
    set(PRECOMPILED_LIB_DIR "libs/windows/amd64")

elseif(${CMAKE_SYSTEM_PROCESSOR} STREQUAL "x86" AND WIN32)
    message(STATUS "Compiling for Windows x86")
    set(PRECOMPILED_LIB_DIR "libs/windows/i386")

elseif(${CMAKE_SYSTEM_PROCESSOR} STREQUAL "x86_64" AND UNIX AND NOT APPLE)
    message(STATUS "Compiling for Linux x86_64")
    set(PRECOMPILED_LIB_DIR "lib/linux/amd64")

elseif(${CMAKE_SYSTEM_PROCESSOR} STREQUAL "x86_64" AND APPLE)
    message(STATUS "Compiling for macOS x86_64")
    set(PRECOMPILED_LIB_DIR "lib/macos/amd64")

elseif(${CMAKE_SYSTEM_PROCESSOR} STREQUAL "arm64" AND APPLE)
    message(STATUS "Compiling for macOS arm64")
    set(PRECOMPILED_LIB_DIR "lib/macos/arm64")

else()
    message(FATAL_ERROR "Unsupported operating system or architecture: ${CMAKE_SYSTEM_PROCESSOR}")
endif()
file(GLOB CRASHPAD_LIBS "${CMAKE_CURRENT_SOURCE_DIR}/${PRECOMPILED_LIB_DIR}/*")
message(STATUS "Found the following crashpad libraries:")
foreach(LIB ${CRASHPAD_LIBS})
    message(STATUS "  ${LIB}")
endforeach()

add_library(crashpad INTERFACE)
target_compile_definitions(crashpad INTERFACE -DNOMINMAX)
# set_source_files_properties(${CMAKE_CURRNENT_SOURCE_DIR}/include/mini_chromium/base/strings/string_piece.h PROPERTIES COMPILE_FLAGS -DNOMINMAX)
target_include_directories(crashpad INTERFACE include/crashpad)
target_include_directories(crashpad INTERFACE include/mini_chromium)
target_link_libraries(crashpad INTERFACE ${CRASHPAD_LIBS})

if(UNIX)
	find_package(Threads REQUIRED)
	target_link_libraries(crashpad INTERFACE Threads::Threads)
endif()

if(APPLE)
    find_library(MAC_FRAME_COCOA Cocoa)
    find_library(MAC_FRAME_IOKIT IOKit)
    find_library(MAC_FRAME_SECURITY Security)
    target_link_libraries(crashpad INTERFACE bsm)

    target_link_libraries(crashpad INTERFACE ${MAC_FRAME_COCOA})
    target_link_libraries(crashpad INTERFACE ${MAC_FRAME_IOKIT})
    target_link_libraries(crashpad INTERFACE ${MAC_FRAME_SECURITY})
endif()

# Copy crashpad handler to build directory
file(COPY ${HANDLER_FILE} DESTINATION ${PROJECT_BINARY_DIR})
