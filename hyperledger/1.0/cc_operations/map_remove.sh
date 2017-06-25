#!/bin/bash

source cc_operations/globalFunctions.sh

echo_b "Channel name : "$CHANNEL_NAME

if [ "$#" -ne 2 ]; then
	echo_r "=========================== Usage: map_remove map key =========================== "
    echo_r "e.g. map_remove VOTERS voterKey"
    exit 1
fi

map_remove 2 "$1" "$2"

echo
echo_g "================================== Removed "$2" from "$1" ================================== "
echo

exit 0
