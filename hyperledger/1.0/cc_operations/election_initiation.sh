#!/bin/bash

source cc_operations/globalFunctions.sh

echo_b "Channel name : "$CHANNEL_NAME

ELECTION_PUBLIC_FILE=proofs/election_public.log.txt
ZEUS_PUBLIC_FILE=proofs/zeus_public.log.txt
CRYPTOSYSTEM_FILE=proofs/cryptosystem.log.txt
ELECTION_FINGERPRINT_FILE=proofs/election_fingerprint.log.txt
ZEUS_KEY_PROO_FILEF=proofs/zeus_key_proof.log.txt
TRUSTEE_FILE=proofs/trustees.log.txt
CANDIDATES_FILE=proofs/candidates.log.txt
ELECTION_REPORT_FILE=proofs/election_report.log.txt
VOTER_FILE=proofs/voters.log.txt
VOTER_AUDIT_CODES_FILE=proofs/voter_audit_codes.log.txt

function add_voter () {
	echo_b "Adding voter ""$1"
	insert_map_verify 2 VOTERS "$1" "$2"
}

function add_trustee () {
	echo_b "Adding trustee ""$1"
	insert_map_verify 2 TRUSTEES "$1" "$2"
}

function add_voter_audit_codes () {
	echo_b "Adding voter audit codes""$1"
	insert_map_verify 2 VOTERS_AUDIT_CODES "$1" "$2"
}

function add_voters () {
	while read voter; do
		IFS=':' tokens=( $voter )
		add_voter ${tokens[0]} ${tokens[1]}
	done <$VOTER_FILE
}

function add_trustees () {
	while read trustee; do
		IFS=':' tokens=( $trustee )
		add_trustee ${tokens[0]} ${tokens[1]}
	done <$TRUSTEE_FILE
}

function add_voters_audit_codes () {
	while read voter_code_s; do
		IFS=':' tokens=( $voter_code_s )
		add_voter_audit_codes ${tokens[0]} ${tokens[1]}
	done <$VOTER_AUDIT_CODES_FILE
}


##################### Add election information #####################
/bin/bash ./cc_operations/set.sh election_public $(cat $ELECTION_PUBLIC_FILE)

/bin/bash ./cc_operations/set.sh zeus_public $(cat $ZEUS_PUBLIC_FILE)

/bin/bash ./cc_operations/set.sh cryptosystem $(cat $CRYPTOSYSTEM_FILE) # list, for start add it as a string..

/bin/bash ./cc_operations/set.sh election_fingerprint $(cat $ELECTION_FINGERPRINT_FILE)

/bin/bash ./cc_operations/set.sh zeus_key_proof $(cat $ZEUS_KEY_PROOF_FILE) # list, for start add it as a string..

add_trustees

/bin/bash ./cc_operations/set.sh candidates $(cat $CANDIDATES_FILE) # list, for start add it as a string..

/bin/bash ./cc_operations/set.sh election_report $(cat $ELECTION_REPORT_FILE) # for start add it as a string. Could be a map of maps..

add_voters

add_voters_audit_codes

echo
echo_g "===================== All GOOD, election initiation completed ===================== "
echo

exit 0
