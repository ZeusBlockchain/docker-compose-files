#!/bin/bash

source cc_operations/globalFunctions.sh

echo_b "Channel name : "$CHANNEL_NAME

RESULTS_FILE=proofs/results.log.txt
VOTER_AUDIT_CODES_FILE=proofs/voter_audit_codes.log.txt


##################### Add Partial Decryption phase information #####################

/bin/bash ./cc_operations/set_verify.sh "RESULTS" "$(cat $RESULTS_FILE)"

reveal_encrypted_map_fields "VOTER_AUDIT_CODES_REVEALED" "$VOTER_AUDIT_CODES_FILE"


echo
echo_g "===================== All GOOD, Partial Decryption Phase completed ===================== "
echo

exit 0
