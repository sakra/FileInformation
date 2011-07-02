# - CMake module for getting file information such as size and modification date
#
# The module does not introduce new commands. It overrides the built-in CMake command
# file to provide two additional sub-commands SIZE and TIMESTAMP:
#
#  file (SIZE filename variable)
#  SIZE will store the size of the file in bytes into the variable.
#
#  file (TIMESTAMP filename variable)
#  TIMESTAMP will store the modification date of the file into the variable as an
#  ISO 8601 formatted string (e.g., "2011-07-02T13:00:22").

get_filename_component(FileInformation_CMAKE_MODULE_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
set (FileInformation_CMAKE_MODULE_VERSION "1.0.0")

macro (file)
	if ("${ARGV0}" MATCHES "SIZE|TIMESTAMP")
		if (NOT ${ARGC} EQUAL 3)
			message (FATAL_ERROR "file sub-command ${ARGV0} requires two arguments.")
		endif()
		set (_filePath "${ARGV1}")
		set (_varName "${ARGV2}")
		get_filename_component(_filePath "${_filePath}" ABSOLUTE)
		if (NOT EXISTS "${_filePath}")
			message (FATAL_ERROR "File ${_filePath} does not exist.")
		endif()
		if ("${ARGV0}" STREQUAL "SIZE" AND IS_DIRECTORY "${_filePath}")
			message (FATAL_ERROR "Path ${_filePath} is a directory.")
		endif()
		if (CMAKE_HOST_UNIX)
			set (_helperScript "${FileInformation_CMAKE_MODULE_DIR}/FileInformation.sh")
			# make sure helper script is executable
			execute_process(COMMAND chmod "-f" "+x" "${_helperScript}" TIMEOUT 5)
		elseif (CMAKE_HOST_WIN32)
			set (_helperScript "${FileInformation_CMAKE_MODULE_DIR}/FileInformation.cmd")
		else()
			message (FATAL_ERROR "Unsupported host platform ${CMAKE_HOST_SYSTEM_NAME}.")
		endif()
		file (TO_NATIVE_PATH "${_filePath}" _nativePath)
		string (TOLOWER "${ARGV0}" _cmd)
		execute_process(
			COMMAND "${_helperScript}" "--${_cmd}" "${_nativePath}"
			TIMEOUT 5
			RESULT_VARIABLE _exitCode
			OUTPUT_VARIABLE ${_varName}
			OUTPUT_STRIP_TRAILING_WHITESPACE)
		if (NOT ${_exitCode} EQUAL 0)
			message (SEND_ERROR "file sub-command ${ARGV0} failed for ${_filePath}.")
		endif()
	else()
		_file (${ARGV})
	endif()
endmacro()
