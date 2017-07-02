#!/bin/bash

source cc_operations/globalFunctions.sh

echo_b "Channel name : "$CHANNEL_NAME

TRUSTEE_FACTORS_FILE=proofs/trustee_factors.log.txt

##################### Add Partial Decryption phase information #####################

while read line; do
    /bin/bash ./cc_operations/insert_list_verify.sh "TRUSTEE_FACTORS" "$line"
done <$TRUSTEE_FACTORS_FILE

echo
echo_g "===================== All GOOD, Partial Decryption Phase completed ===================== "
echo

exit 0
