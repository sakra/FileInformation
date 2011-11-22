# - CMake module for getting file information such as size and modification date
#
# This module overrides the built-in CMake command file to provide two additional sub-commands
# SIZE and TIMESTAMP on all platforms. Under UNIX the sub-commands USER_NAME, GROUP_NAME and
# PERMISSIONS are also provided.
#
#  file (SIZE filename var)
#  SIZE will store the size of the file in bytes into the variable.
#
#  file (TIMESTAMP filename var)
#  TIMESTAMP will store the modification date of the file into the variable as an ISO 8601
#  formatted string (e.g., "2011-07-02T13:00:22"). The chronological order of two timestamps
#  can be determined with a STRLESS, STRGREATER or STREQUAL expression.
#
#  get_timestamp_component (var timestamp TIMESTAMP|DATE|TIME|YEAR|MONTH|DAY|HOUR|MINUTE|SECOND ...)
#  gets a specific component of a ISO 8601 formatted string. Multiple components can be
#  retrieved at the same time as a list.
#
#  current_timestamp (var [ TIMESTAMP|DATE|TIME|YEAR|MONTH|DAY|HOUR|MINUTE|SECOND ... ])
#  will store the current date and time into the variable as an ISO 8601 formatted string.
#  Optionally components of the current date and time can be retrieved as a list instead.
#
#  The following sub-commands are available on UNIX and Apple (Mac OS X) only:
#
#  file (USER_NAME filename var)
#  USER_NAME will store the user name of the file owner into the variable.
#
#  file (GROUP_NAME filename var)
#  GROUP_NAME will store the group name of the file owner into the variable.
#
#  file (PERMISSIONS filename var)
#  PERMISSIONS will store the the permissions of the file into the variable as a list.
#  Valid permissions are OWNER_READ, OWNER_WRITE, OWNER_EXECUTE, GROUP_READ, GROUP_WRITE,
#  GROUP_EXECUTE, WORLD_READ, WORLD_WRITE, WORLD_EXECUTE, SETUID, and SETGID.

get_filename_component(FileInformation_CMAKE_MODULE_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
set (FileInformation_CMAKE_MODULE_VERSION "1.1.0")

# private function which invokes platform specific helper script
function (_invoke_helper_script _command _filePath _outputVar _exitCodeVar)
	if (CMAKE_HOST_UNIX)
		set (_helperScript "${FileInformation_CMAKE_MODULE_DIR}/FileInformation.sh")
		# make sure helper script is executable
		execute_process(COMMAND chmod "-f" "+x" "${_helperScript}" TIMEOUT 5)
	elseif (CMAKE_HOST_WIN32)
		set (_helperScript "${FileInformation_CMAKE_MODULE_DIR}/FileInformation.cmd")
		# Windows requires native paths
		file (TO_NATIVE_PATH "${_helperScript}" _helperScript)
		if (_filePath)
			file (TO_NATIVE_PATH "${_filePath}" _filePath)
		endif()
	else()
		message (FATAL_ERROR "Unsupported host platform ${CMAKE_HOST_SYSTEM_NAME}.")
	endif()
	string (TOLOWER "${_command}" _cmd)
	execute_process(
		COMMAND "${_helperScript}" "--${_cmd}" "${_filePath}"
		TIMEOUT 5
		RESULT_VARIABLE _result
		OUTPUT_VARIABLE _output
		OUTPUT_STRIP_TRAILING_WHITESPACE)
	set (${_exitCodeVar} ${_result} PARENT_SCOPE)
	set (${_outputVar} ${_output} PARENT_SCOPE)
endfunction()

if (NOT COMMAND get_timestamp_component)
	# do not override get_timestamp_component if it already exists
	function (get_timestamp_component _outputVar _timestamp)
		if (${ARGC} LESS 3)
			message (FATAL_ERROR "timestamp requires at least three arguments.")
		endif()
		set (_result "")
		string (STRIP "${_timeStamp}" _timeStamp)
		if (NOT "${_timeStamp}" MATCHES
			"[0-9][0-9][0-9][0-9](-[0-9][0-9](-[0-9][0-9])?)?T[0-9][0-9](:[0-9][0-9](:[0-9][0-9])?)?")
			message (SEND_ERROR
				"get_timestamp_component ${_timeStamp} is not an ISO 8601 string.")
			set (_result "TIMESTAMP-NOTFOUND")
		else()
			string (LENGTH "${_timeStamp}" _timeStampLength)
			foreach (_component ${ARGN})
				if ("${_component}" STREQUAL "TIMESTAMP" AND _timeStampLength GREATER 18)
					string (SUBSTRING "${_timeStamp}" 0 19 _componentValue)
				elseif ("${_component}" STREQUAL "DATE" AND _timeStampLength GREATER 9)
					string (SUBSTRING "${_timeStamp}" 0 10 _componentValue)
				elseif ("${_component}" STREQUAL "TIME" AND _timeStampLength GREATER 18)
					string (SUBSTRING "${_timeStamp}" 11 8 _componentValue)
				elseif ("${_component}" STREQUAL "YEAR" AND _timeStampLength GREATER 3)
					string (SUBSTRING "${_timeStamp}" 0 4 _componentValue)
				elseif ("${_component}" STREQUAL "MONTH" AND _timeStampLength GREATER 6)
					string (SUBSTRING "${_timeStamp}" 5 2 _componentValue)
				elseif ("${_component}" STREQUAL "DAY" AND _timeStampLength GREATER 9)
					string (SUBSTRING "${_timeStamp}" 8 2 _componentValue)
				elseif ("${_component}" STREQUAL "HOUR" AND _timeStampLength GREATER 12)
					string (SUBSTRING "${_timeStamp}" 11 2 _componentValue)
				elseif ("${_component}" STREQUAL "MINUTE" AND _timeStampLength GREATER 15)
					string (SUBSTRING "${_timeStamp}" 14 2 _componentValue)
				elseif ("${_component}" STREQUAL "SECOND" AND _timeStampLength GREATER 18)
					string (SUBSTRING "${_timeStamp}" 17 2 _componentValue)
				else()
					message (WARNING "get_timestamp_component cannot extract component ${_component}.")
					set (_componentValue "${_component}-NOTFOUND")
				endif()
				list (APPEND _result ${_componentValue})
			endforeach()
		endif()
		set (${_outputVar} ${_result} PARENT_SCOPE)
	endfunction ()
endif()

if (NOT COMMAND current_timestamp)
	# do not override current_timestamp if it already exists
	function (current_timestamp _outputVar)
		_invoke_helper_script("current_timestamp" "" _result _exitCode)
		if (NOT ${_exitCode} EQUAL 0)
			message (SEND_ERROR "current_timestamp failed.")
			set (_result "TIMESTAMP-NOTFOUND")
		elseif (${ARGC} GREATER 1)
			get_timestamp_component (_result "${_result}" ${ARGN})
		endif()
		set (${_outputVar} ${_result} PARENT_SCOPE)
	endfunction()
endif()

macro (file)
	if ("${ARGV0}" MATCHES "SIZE|TIMESTAMP|PERMISSIONS|USER_NAME|GROUP_NAME")
		if (NOT ${ARGC} EQUAL 3)
			message (FATAL_ERROR "file sub-command ${ARGV0} requires two arguments.")
		endif()
		set (_filePath "${ARGV1}")
		set (_varName "${ARGV2}")
		get_filename_component(_filePath "${_filePath}" ABSOLUTE)
		if (NOT EXISTS "${_filePath}")
			message (FATAL_ERROR "file ${ARGV0} ${_filePath} does not exist.")
		endif()
		if ("${ARGV0}" STREQUAL "SIZE" AND IS_DIRECTORY "${_filePath}")
			message (FATAL_ERROR "file ${ARGV0} ${_filePath} is a directory.")
		endif()
		_invoke_helper_script("${ARGV0}" "${_filePath}" ${_varName} _exitCode)
		if (NOT ${_exitCode} EQUAL 0)
			message (SEND_ERROR "file ${ARGV0} failed for ${_filePath}.")
			set (${_varName} "${ARGV0}-NOTFOUND")
		endif()
	else()
		# pass call to original file function
		_file (${ARGV})
	endif()
endmacro()
