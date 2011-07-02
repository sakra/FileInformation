#!/bin/bash
# helper script for FileInformation CMake module

#logger $# "$@"

INPUT_OPTION=$1

# format timestamp according to ISO 8601
TIMESTAMP_FORMAT=%Y-%m-%dT%H:%M:%S

if [[ $OSTYPE == darwin* || $OSTYPE == freebsd* ]]
then
	# Mac OS X or FreeBSD
	if [ "$INPUT_OPTION" = "--size" ]
	then
		stat -f "%z" "$2"
	elif [ "$INPUT_OPTION" = "--timestamp" ]
	then
		date -r $(stat -f "%m" "$2") "+$TIMESTAMP_FORMAT"
	else
		exit 1
	fi
else
	# other Unices
	if [ "$INPUT_OPTION" = "--size" ]
	then
		stat -c "%s" "$2"
	elif [ "$INPUT_OPTION" = "--timestamp" ]
	then
		date -r "$2" "+$TIMESTAMP_FORMAT"
	else
		exit 1
	fi
fi
