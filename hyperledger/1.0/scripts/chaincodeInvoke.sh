#!/bin/bash

source scripts/setGlobals.sh

echo_b "Channel name : "$CHANNEL_NAME

function verifyResult () {
    if [ $1 -ne 0 ] ; then
        echo_b "!!!!!!!!!!!!!!! "$2" !!!!!!!!!!!!!!!!"
        echo_r "================== ERROR !!! FAILED to execute End-2-End Scenario =================="
        echo
        exit 1
    fi
}

function chaincodeInvoke () {
    PEER=$1
    setGlobals $PEER
    if [ -z "$CORE_PEER_TLS_ENABLED" -o "$CORE_PEER_TLS_ENABLED" = "false" ]; then
        peer chaincode invoke -o orderer.example.com:7050 -C $CHANNEL_NAME -n mycc -c '{"Args":["invoke","'$2'","'$3'","'$4'"]}' >&log.txt
    else
        peer chaincode invoke -o orderer.example.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n mycc -c '{"Args":["invoke","'$2'","'$3'","'$4'"]}' >&log.txt
    fi
    res=$?
    cat log.txt
    verifyResult $res "Invoke execution on PEER$PEER failed "
    echo_g "===================== Invoke transaction on PEER$PEER on channel '$CHANNEL_NAME' is successful ===================== "
    echo
}

if [ "$#" -eq 3 ]; then
    echo_b "Invoke:\t"$1"-->"$3"-->"$2
    chaincodeInvoke 2 "$1" "$2" "$3"
else
    echo_b "Running with default parameters..."
    echo_b "Invoke:\ta-->10-->b"
    chaincodeInvoke 2 a b 10
fi

exit 0
