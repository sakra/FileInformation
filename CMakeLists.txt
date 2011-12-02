# FileInformation example project

cmake_minimum_required(VERSION 2.8.4)

project (FileInformation NONE)

set (CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/Module")

include (FileInformation)

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

message (STATUS "${CMAKE_CURRENT_LIST_FILE} size is ${_size}")
message (STATUS "${CMAKE_CURRENT_LIST_FILE} read content size is ${_contentSize}")
message (STATUS "${CMAKE_CURRENT_LIST_FILE} timestamp is ${_timeStamp}")

get_timestamp_component (_timeStampList ${_timeStamp} YEAR MONTH DAY HOUR MINUTE SECOND)
message (STATUS "${CMAKE_CURRENT_LIST_FILE} timestamp as list is ${_timeStampList}")

if (CMAKE_HOST_UNIX)
	file (USER_NAME "${CMAKE_CURRENT_LIST_FILE}" _userName)
	file (GROUP_NAME "${CMAKE_CURRENT_LIST_FILE}" _groupName)
	file (PERMISSIONS "${CMAKE_CURRENT_LIST_FILE}" _permissions)

	message (STATUS "${CMAKE_CURRENT_LIST_FILE} user name is ${_userName}")
	message (STATUS "${CMAKE_CURRENT_LIST_FILE} group name is ${_groupName}")
	message (STATUS "${CMAKE_CURRENT_LIST_FILE} permissions are ${_permissions}")
endif()

file (TIMESTAMP "${CMAKE_CURRENT_LIST_DIR}" _timeStamp)
message (STATUS "${CMAKE_CURRENT_LIST_DIR} timestamp is ${_timeStamp}")

if (CMAKE_HOST_UNIX)
	file (USER_NAME "${CMAKE_CURRENT_LIST_DIR}" _userName)
	file (GROUP_NAME "${CMAKE_CURRENT_LIST_DIR}" _groupName)
	file (PERMISSIONS "${CMAKE_CURRENT_LIST_DIR}" _permissions)

	message (STATUS "${CMAKE_CURRENT_LIST_DIR} user name is ${_userName}")
	message (STATUS "${CMAKE_CURRENT_LIST_DIR} group name is ${_groupName}")
	message (STATUS "${CMAKE_CURRENT_LIST_DIR} permissions are ${_permissions}")
endif()
