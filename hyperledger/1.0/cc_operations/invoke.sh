#!/bin/bash

source /go/src/github.com/hyperledger/fabric/peer/cc_operations/globalFunctions.sh

echo_b "Channel name : "$CHANNEL_NAME


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


if [ "$#" -ne 3 ]; then
    echo_r "=========================== Usage: invoke from_var to_var value =========================== "
    echo_r "e.g. invoke a b 10"
    exit 1
fi

echo_b "Invoke:\t"$1"-->"$3"-->"$2
chaincodeInvoke 2 "$1" "$2" "$3"

echo
echo_g "============================= Invoked from "$1" to "$2" "$3" ============================="
echo

exit 0
