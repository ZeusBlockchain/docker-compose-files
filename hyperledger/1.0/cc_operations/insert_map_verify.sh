#!/bin/bash

source cc_operations/globalFunctions.sh

echo_b "Channel name : "$CHANNEL_NAME

if [ "$#" -ne 3 ]; then
	echo_r "=========================== Usage: insert_map_verify list key value =========================== "
    echo_r "e.g. insert_map_verify VOTERS voterID voterDetails"
    exit 1
fi

insert_map_verify 2 "$1" "$2" "$3"

echo
echo_g "================================== Added "$2" => "$3" to "$1" ================================== "
echo

exit 0
