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

The module does not introduce new commands. It overrides the built-in CMake command
`file` to provide two additional sub-commands `SIZE` and `TIMESTAMP`:

    file (SIZE filename variable)

`SIZE` will store the size of the file in bytes into the variable.

    file (TIMESTAMP filename variable)

`TIMESTAMP` will store the modification date of the file into the variable as an
[ISO 8601][iso8601] formatted string (e.g., "2011-07-02T13:00:22").

See the file `CMakeLists.txt` file for usage examples.

[cmk]:http://www.cmake.org/cmake/resources/software.html
[cmtut]:http://www.cmake.org/cmake/help/cmake_tutorial.html
[iso8601]:http://www.w3.org/TR/NOTE-datetime.html
