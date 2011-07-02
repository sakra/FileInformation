# FileInformation example project

cmake_minimum_required(VERSION 2.8)

project (FileInformation NONE)

set (CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/Module" ${CMAKE_MODULE_PATH})

include (FileInformation)

file (SIZE CMakeLists.txt _size)
file (TIMESTAMP CMakeLists.txt _timeStamp)
file (READ CMakeLists.txt _content)
string (LENGTH "${_content}" _contentSize)

message (STATUS "CMakeLists.txt size is ${_size}")
message (STATUS "CMakeLists.txt timestamp is ${_timeStamp}")
message (STATUS "CMakeLists.txt read content size is ${_contentSize}")
