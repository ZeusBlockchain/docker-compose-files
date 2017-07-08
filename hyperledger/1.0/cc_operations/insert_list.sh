#!/bin/bash

source cc_operations/globalFunctions.sh

echo_b "Channel name : "$CHANNEL_NAME

if [ "$#" -ne 2 ]; then
	echo_r "=========================== Usage: insert_list list element =========================== "
    echo_r "e.g. insert_list VOTES voteID"
    exit 1
fi

insert_list 2 "$1" "$2"

echo
echo_g "================================== Added "$2" to "$1" ================================== "
echo

exit 0
