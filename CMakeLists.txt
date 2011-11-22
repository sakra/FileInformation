# FileInformation example project

cmake_minimum_required(VERSION 2.8.4)

project (FileInformation NONE)

set (CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/Module")

include (FileInformation)

get_filename_component(_name "${CMAKE_CURRENT_LIST_FILE}" NAME)

current_timestamp(_timeStamp)
message (STATUS "current timestamp is ${_timeStamp}")
current_timestamp(_date DATE)
message (STATUS "current date is ${_date}")
current_timestamp(_time TIME)
message (STATUS "current time is ${_time}")
current_timestamp(_time YEAR)
message (STATUS "current year is ${_time}")

file (SIZE "${CMAKE_CURRENT_LIST_FILE}" _size)
file (TIMESTAMP "${CMAKE_CURRENT_LIST_FILE}" _timeStamp)
file (READ "${CMAKE_CURRENT_LIST_FILE}" _content)
string (LENGTH "${_content}" _contentSize)

message (STATUS "${_name} size is ${_size}")
message (STATUS "${_name} read content size is ${_contentSize}")
message (STATUS "${_name} timestamp is ${_timeStamp}")

get_timestamp_component (_timeStampList ${_timeStamp} YEAR MONTH DAY HOUR MINUTE SECOND)
message (STATUS "${_name} timestamp as list is ${_timeStampList}")

file (TIMESTAMP "${CMAKE_CURRENT_LIST_DIR}" _timeStamp)
message (STATUS "${CMAKE_CURRENT_LIST_DIR} timestamp is ${_timeStamp}")

if (CMAKE_HOST_UNIX)

	file (USER_NAME "${CMAKE_CURRENT_LIST_FILE}" _userName)
	file (GROUP_NAME "${CMAKE_CURRENT_LIST_FILE}" _groupName)
	file (PERMISSIONS "${CMAKE_CURRENT_LIST_FILE}" _permissions)

	message (STATUS "${_name} user name of file owner is ${_userName}")
	message (STATUS "${_name} group name of file owner is ${_groupName}")
	message (STATUS "${_name} permissions are ${_permissions}")

endif()
