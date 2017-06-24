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
	VOTERS="["
	while read voter; do
		VOTERS=$VOTERS$voter","
		add_voter $voter
	done <$VOTERFILE
	VOTERS="${VOTERS::-1}" # Remove last ','
	VOTERS=$VOTERS"]"
	set_verify 2 VOTERS $VOTERS
}

function add_trustees () {
	TRUSTEES="["
	while read trustee; do
		TRUSTEES=$TRUSTEES$trustee","
		add_trustee $trustee
	done <$TRUSTEEFILE
	TRUSTEES="${TRUSTEES::-1}" # Remove last ','
	TRUSTEES=$TRUSTEES"]"
	set_verify 2 TRUSTEES $TRUSTEES
}

# Add election information
add_voters
add_trustees


echo
echo_g "===================== All GOOD, election initiation completed ===================== "
echo

exit 0
