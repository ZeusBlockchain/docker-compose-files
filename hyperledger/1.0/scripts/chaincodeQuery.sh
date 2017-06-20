#!/bin/bash

source scripts/setGlobals.sh

echo_b "Channel name : "$CHANNEL_NAME

function chaincodeQuery () {
    PEER=$1
    echo_b "===================== Querying on PEER$PEER on channel '$CHANNEL_NAME'... ===================== "
    setGlobals $PEER
    local rc=1
    local starttime=$(date +%s)

    # continue to poll
    # we either get a successful response, or reach TIMEOUT
    while test "$(($(date +%s)-starttime))" -lt "$TIMEOUT" -a $rc -ne 0
    do
        sleep 3
        echo_b "Attempting to Query PEER$PEER ...$(($(date +%s)-starttime)) secs"
        peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query","'$2'"]}' >&log.txt
        test $? -eq 0 && VALUE=$(cat log.txt | awk '/Query Result/ {print $NF}')
        test "$VALUE" = "$3" && let rc=0
    done
    echo
    cat log.txt
    if test $rc -eq 0 ; then
        echo_g "===================== Query on PEER$PEER on channel '$CHANNEL_NAME' is successful ===================== "
    else
        echo_r "!!!!!!!!!!!!!!! Query result on PEER$PEER is INVALID !!!!!!!!!!!!!!!!"
        echo_r "================== ERROR !!! FAILED to execute End-2-End Scenario =================="
        echo
        exit 1
    fi
}

function chaincodeQueryNoVerification () {
    PEER=$1
    echo_b "===================== Querying on PEER$PEER on channel '$CHANNEL_NAME'... ===================== "
    setGlobals $PEER
    local starttime=$(date +%s)

    # continue to poll
    # we either get a successful response, or reach TIMEOUT
    echo_b "Attempting to Query PEER$PEER ...$(($(date +%s)-starttime)) secs"
    peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query","'$2'"]}' >&log.txt
    test $? -eq 0 && VALUE=$(cat log.txt | awk '/Query Result/ {print $NF}')
    echo
    cat log.txt
}


#Query on chaincode on Peer0/Org1
if [ -z "$2" ]; then
    echo_b "Querying chaincode on org1/peer0..."
    chaincodeQueryNoVerification 2 "$1"
else
    echo_b "Querying chaincode on org1/peer0..."
    chaincodeQuery 2 "$1" "$2"
fi

exit 0
