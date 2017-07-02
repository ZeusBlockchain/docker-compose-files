#!/bin/bash

source cc_operations/globalFunctions.sh

echo_b "Channel name : "$CHANNEL_NAME

RESULTS_FILE=proofs/results.log.txt

##################### Add Partial Decryption phase information #####################

/bin/bash ./cc_operations/set_verify.sh "RESULTS" "$(cat $RESULTS_FILE)"

echo
echo_g "===================== All GOOD, Partial Decryption Phase completed ===================== "
echo

exit 0
