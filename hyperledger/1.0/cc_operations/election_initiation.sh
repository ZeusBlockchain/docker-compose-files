#!/bin/bash

source cc_operations/globalFunctions.sh

echo_b "Channel name : "$CHANNEL_NAME

VOTERFILE=cc_operations/voters.txt
TRUSTEEFILE=cc_operations/trustees.txt

function add_voter () {
	echo_b "Adding voter "$line
	set_verify v_$1 -1
}

function add_trustee () {
	echo_b "Adding trustee "$line
	set_verify t_$1 -1
}

function add_voters () {
	while read voter; do
		add_voter $voter
	done <$VOTERFILE
}

function add_trustees () {
	while read trustee; do
		add_voter $trustee
	done <$TRUSTEEFILE
}

# Add election information
add_voters
add_trustees


echo
echo_g "===================== All GOOD, election initiation completed ===================== "
echo

exit 0
