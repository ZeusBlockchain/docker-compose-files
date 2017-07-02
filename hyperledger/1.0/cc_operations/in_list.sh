#!/bin/bash

source cc_operations/globalFunctions.sh

echo_b "Channel name : "$CHANNEL_NAME

if [ "$#" -ne 2 ]; then
	echo_r "=========================== Usage: in_list.sh list element =========================== "
    echo_r "e.g. in_list.sh VOTES voteID"
    exit 1
fi

inList 2 "$1" "$2"

echo
echo_g "===================================== Query "$1" ===================================== "
echo

exit 0
