#!/bin/bash

source cc_operations/globalFunctions.sh

echo_b "Channel name : "$CHANNEL_NAME

if [ "$#" -ne 2 ]; then
	echo_r "=========================== Usage: insert_list list element =========================== "
    echo_r "e.g. insert_list VOTES voteID"
    exit 1
fi

insert_list_verify 2 "$1" "$2"

echo
echo_g "================================== Removed "$2" from "$1" ================================== "
echo

exit 0
