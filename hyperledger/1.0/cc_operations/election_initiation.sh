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
	VOTERS=""
	while read voter; do
		VOTERS=$VOTERS$voter","
		add_voter $voter
	done <$VOTERFILE
	VOTERS="${VOTERS::-1}" # Remove last ','
	# set_map_verify 2 VOTERS $VOTERS  # Verification will not work due to map ordering. Need to fix this later
	set_map 2 VOTERS $VOTERS  # Currently no verification
}

function add_trustees () {
	TRUSTEES=""
	while read trustee; do
		TRUSTEES=$TRUSTEES$trustee","
		add_trustee $trustee
	done <$TRUSTEEFILE
	TRUSTEES="${TRUSTEES::-1}" # Remove last ','
	# set_map_verify 2 TRUSTEES $TRUSTEES  # Verification will not work due to map ordering. Need to fix this later
	set_map 2 TRUSTEES $TRUSTEES  # Currently no verification
}

# Add election information
add_voters
add_trustees


echo
echo_g "===================== All GOOD, election initiation completed ===================== "
echo

exit 0
