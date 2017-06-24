#!/bin/bash

source cc_operations/globalFunctions.sh

echo_b "Channel name : "$CHANNEL_NAME

#Query on chaincode on Peer0/Org1
if [ -z "$2" ]; then
    echo_b "Querying chaincode on org1/peer0..."
    chaincodeQueryMapNoVerification 2 "$1"
else
    echo_b "Querying chaincode on org1/peer0..."
    chaincodeQuery 2 "$1" "$2"
fi

echo
echo_g "===================================== Query "$1" ===================================== "
echo

exit 0
