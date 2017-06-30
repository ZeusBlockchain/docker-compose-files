#!/bin/bash

source cc_operations/globalFunctions.sh

echo_b "Channel name : "$CHANNEL_NAME

VOTERFILE=proofs/voters.log.txt
TRUSTEEFILE=proofs/trustees.log.txt

function add_voter () {
	echo_b "Adding voter ""$1"
	insert_map_verify 2 VOTERS "$1" "$2"
}

function add_trustee () {
	echo_b "Adding trustee ""$1"
	insert_map_verify 2 TRUSTEES "$1" "$2"
}

function add_voters () {
	while read voter; do
		IFS=':' tokens=( $voter )
		add_voter ${tokens[0]} ${tokens[1]}
	done <$VOTERFILE
}

function add_trustees () {
	while read trustee; do
		IFS=':' tokens=( $trustee )
		add_trustee ${tokens[0]} ${tokens[1]}
	done <$TRUSTEEFILE
}

# Add election information
add_voters
add_trustees


echo
echo_g "===================== All GOOD, election initiation completed ===================== "
echo

exit 0
