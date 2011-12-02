FileInformation
===============

FindMathematica is a CMake module that provides functionality for getting file information such as file size and file modification date and time.

Features
--------

* Works with Windows, Linux and Mac OS X.
* Uses native scripting commands to compute provided file information.

Requirements
------------

* [CMake 2.8][cmk] or newer. The executable `cmake` should be on the system path.

Installation
------------

Copy the files in the directory `Module` to the module directory of your CMake project.
Be sure to add the module directory to the CMake module search path, e.g.:

    set (CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/Module" ${CMAKE_MODULE_PATH})

Usage
-----

If you are new to CMake, check out the [CMake tutorial][cmtut] first.

In your `CMakeLists.txt` file include the module `FileInformation`:

    include (FileInformation)

The following commands are available:

    get_timestamp_component(variable timestamp component)

`get_timestamp_component` gets a specific component of an [ISO 8601][iso8601] formatted string.
Valid components are `DATE`, `TIME`, `YEAR`, `MONTH`, `DAY`, `HOUR`, `MINUTE` and `SECOND`.

    current_timestamp (variable [ component ])

`current_timestamp` will store a timestamp representing the current date and time into the variable
as an [ISO 8601][iso8601] formatted string (e.g., "2011-11-21T21:15:44").

Furthermore, the module overrides the built-in CMake command `file` to provide two additional
sub-commands `SIZE` and `TIMESTAMP` on all platforms:

    file (SIZE filename variable)

`SIZE` will store the size of the file in bytes into the variable.

    file (TIMESTAMP filename variable)

`TIMESTAMP` will store the modification date and time of the file into the variable as an
[ISO 8601][iso8601] formatted string (e.g., "2011-07-02T13:00:22").

Under Linux and Mac OS X the following sub-commands are available, too:

    file (USER_NAME filename variable)

`USER_NAME` will store the user name of the file owner into the variable.

    file (GROUP_NAME filename variable)

`GROUP_NAME` will store the group name of the file owner into the variable.

    file (PERMISSIONS filename variable)

`PERMISSIONS` will store the permissions of the file into the variable as a list.
Valid permissions are `OWNER_READ`, `OWNER_WRITE`, `OWNER_EXECUTE`, `GROUP_READ`,
`GROUP_WRITE`, `GROUP_EXECUTE`, `WORLD_READ`, `WORLD_WRITE`, `WORLD_EXECUTE`, 
`SETUID`, and `SETGID`.

See the file `CMakeLists.txt` file for usage examples.

[cmk]:http://www.cmake.org/cmake/resources/software.html
[cmtut]:http://www.cmake.org/cmake/help/cmake_tutorial.html
[iso8601]:http://www.w3.org/TR/NOTE-datetime.html
