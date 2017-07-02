#!/bin/bash

source cc_operations/globalFunctions.sh

echo_b "Channel name : "$CHANNEL_NAME

MIX_RANDOM_COLLECTIONS_FILE=proofs/mix_random_collections.log.txt
MIX_OFFSET_COLLECTIONS_FILE=proofs/mix_offset_collections.log.txt
MIX_PUBLIC_FILE=proofs/mix_public.log.txt
MIX_GENERATOR_FILE=proofs/mix_generator.log.txt
MIX_CIPHER_COLLECTIONS_FILE=proofs/mix_cipher_collections.log.txt
MIX_CHALLENGE_FILE=proofs/mix_challenge.log.txt
MIX_ORIGINAL_CIPHERS_FILE=proofs/mix_original_ciphers.log.txt
MIX_MODULUS_FILE=proofs/mix_modulus.log.txt
MIX_MIXED_CIPHERS_FILE=proofs/mix_mixed_ciphers.log.txt
MIX_ORDER_FILE=proofs/mix_order.log.txt


##################### Add voting phase information #####################

while read line
do
    IFS=']' tokens=( $line )
    for token in ${tokens[@]}
    do
        /bin/bash ./cc_operations/insert_list_verify.sh "MIX_RANDOM_COLLECTIONS" "${token:3}"
    done
done <$MIX_RANDOM_COLLECTIONS_FILE
while read line
do
    IFS=']' tokens=( $line )
    for token in ${tokens[@]}
    do
        /bin/bash ./cc_operations/insert_list_verify.sh "MIX_OFFSET_COLLECTIONS" "${token:3}"
    done
done <$MIX_OFFSET_COLLECTIONS_FILE

/bin/bash ./cc_operations/set_verify.sh "MIX_PUBLIC" "$(cat $MIX_PUBLIC_FILE)"

/bin/bash ./cc_operations/set_verify.sh "MIX_GENERATOR" "$(cat $MIX_GENERATOR_FILE)"

while read line
do
    IFS=']]' tokens=( $line )
    for token in ${tokens[@]}
    do
        /bin/bash ./cc_operations/insert_list_verify.sh "MIX_CIPHER_COLLECTIONS" "${token:3}"
    done
done <$MIX_CIPHER_COLLECTIONS_FILE

/bin/bash ./cc_operations/set_verify.sh "MIX_CHALLENGE" "$(cat $MIX_CHALLENGE_FILE)"

while read line
do
    IFS=']' tokens=( $line )
    for token in ${tokens[@]}
    do
        /bin/bash ./cc_operations/insert_list_verify.sh "MIX_ORIGINAL_CIPHERS" "${token:3}"
    done
done <$MIX_ORIGINAL_CIPHERS_FILE

/bin/bash ./cc_operations/set_verify.sh "MIX_MODULUS" "$(cat $MIX_MODULUS_FILE)"

while read line
do
    IFS=']' tokens=( $line )
    for token in ${tokens[@]}
    do
        /bin/bash ./cc_operations/insert_list_verify.sh "MIX_MIXED_CIPHERS" "${token:3}"
    done
done <$MIX_MIXED_CIPHERS_FILE

/bin/bash ./cc_operations/set_verify.sh "MIX_ORDER" "$(cat $MIX_ORDER_FILE)"

echo
echo_g "===================== All GOOD, Voting Phase completed ===================== "
echo

exit 0
