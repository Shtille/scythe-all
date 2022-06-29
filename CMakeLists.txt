cmake_minimum_required(VERSION 3.13 FATAL_ERROR)

project(scythe_all)

add_subdirectory(thirdparty)

set(SCYTHE_THIRDPARTY_DIR "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty")
add_subdirectory(scythe)

add_subdirectory(demos)