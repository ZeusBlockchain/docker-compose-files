#!/bin/bash

source cc_operations/globalFunctions.sh

echo_b "Channel name : "$CHANNEL_NAME

ELECTION_PUBLIC_FILE=proofs/election_public.log.txt
ZEUS_PUBLIC_FILE=proofs/zeus_public.log.txt
CRYPTOSYSTEM_FILE=proofs/cryptosystem.log.txt
ELECTION_FINGERPRINT_FILE=proofs/election_fingerprint.log.txt
ZEUS_KEY_PROOF_FILE=proofs/zeus_key_proof.log.txt
TRUSTEES_FILE=proofs/trustees.log.txt
CANDIDATES_FILE=proofs/candidates.log.txt
ELECTION_REPORT_FILE=proofs/election_report.log.txt
VOTERS_FILE=proofs/voters.log.txt
VOTER_AUDIT_CODES_FILE=proofs/voter_audit_codes.log.txt

##################### Add election information #####################

/bin/bash ./cc_operations/set_verify.sh election_public "$(cat $ELECTION_PUBLIC_FILE)"

/bin/bash ./cc_operations/set_verify.sh zeus_public "$(cat $ZEUS_PUBLIC_FILE)"

/bin/bash ./cc_operations/set_verify.sh cryptosystem "$(cat $CRYPTOSYSTEM_FILE)" # list, for start add it as a string..

/bin/bash ./cc_operations/set_verify.sh election_fingerprint "$(cat $ELECTION_FINGERPRINT_FILE)"

/bin/bash ./cc_operations/set_verify.sh zeus_key_proof "$(cat $ZEUS_KEY_PROOF_FILE)" # list, for start add it as a string..

add_map_fields "TRUSTEES" "$TRUSTEES_FILE"

set_list_verify 2 "CANDIDATES" "$(cat $CANDIDATES_FILE)"

/bin/bash ./cc_operations/set_verify.sh candidates "$(cat $CANDIDATES_FILE)" # list, for start add it as a string..

add_map_fields "ELECTION_REPORT" "$ELECTION_REPORT_FILE"

add_map_fields "VOTERS" "$VOTERS_FILE"

add_map_fields "VOTER_AUDIT_CODES" "$VOTER_AUDIT_CODES_FILE"

echo
echo_g "===================== All GOOD, Election Initiation Phase completed ===================== "
echo

exit 0
