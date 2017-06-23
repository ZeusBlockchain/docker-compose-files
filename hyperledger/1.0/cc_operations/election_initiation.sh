#!/bin/bash

source cc_operations/globalFunctions.sh

echo_b "Channel name : "$CHANNEL_NAME

VOTERFILE=cc_operations/voters.txt
TRUSTEEFILE=cc_operations/trustees.txt

function add_voter () {
	echo_b "Adding voter "$1
	set_verify 2 v_$1 -1
}

function add_trustee () {
	echo_b "Adding trustee "$1
	set_verify 2 t_$1 -1
}

function add_voters () {
	while read voter; do
		add_voter $voter
	done <$VOTERFILE
}

function add_trustees () {
	while read trustee; do
		add_trustee $trustee
	done <$TRUSTEEFILE
}

# Add election information
add_voters
add_trustees


echo
echo_g "===================== All GOOD, election initiation completed ===================== "
echo

exit 0
