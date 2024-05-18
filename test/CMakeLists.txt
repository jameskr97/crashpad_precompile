cmake_minimum_required(VERSION 3.15.0)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_subdirectory(libs/crashpad)

project(TestProject)
add_executable(TestApp src/main.cpp)
target_link_libraries(TestApp PRIVATE crashpad)