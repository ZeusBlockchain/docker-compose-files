#!/bin/bash

source cc_operations/globalFunctions.sh

echo_b "Channel name : "$CHANNEL_NAME

if [ "$#" -ne 2 ]; then
	echo_r "=========================== Usage: set variable value =========================== "
    echo_r "e.g. set b 10"
    exit 1
fi

echo_b "Add:\t"$1"("$2")"
set 2 "$1" "$2"

echo
echo_g "================================== Added "$2" to "$1" ================================== "
echo

exit 0
