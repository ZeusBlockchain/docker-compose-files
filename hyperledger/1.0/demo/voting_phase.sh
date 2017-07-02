#!/bin/bash

source cc_operations/globalFunctions.sh

echo_b "Channel name : "$CHANNEL_NAME

VOTES_FILE=proofs/votes.log.txt
AUDIT_REQUESTS_FILE=proofs/audit_requests.log.txt
AUDIT_PUBLICATIONS_FILE=proofs/audit_publications.log.txt
CAST_VOTES_FILE=proofs/cast_votes.log.txt
EXCLUDED_VOTERS_FILE=proofs/excluded_voters.log.txt

##################### Add voting phase information #####################

while read line; do
    /bin/bash ./cc_operations/insert_list_verify.sh "VOTES" "$line"
done <$VOTES_FILE

/bin/bash ./cc_operations/set_verify.sh "AUDIT_REQUESTS" "$(cat $AUDIT_REQUESTS_FILE)"

/bin/bash ./cc_operations/set_verify.sh "AUDIT_PUBLICATIONS" "$(cat $AUDIT_PUBLICATIONS_FILE)"

add_map_fields "CAST_VOTES" "$CAST_VOTES_FILE"

/bin/bash ./cc_operations/set_verify.sh "EXCLUDED_VOTERS" "$(cat $EXCLUDED_VOTERS_FILE)"


echo
echo_g "===================== All GOOD, Voting Phase completed ===================== "
echo

exit 0
