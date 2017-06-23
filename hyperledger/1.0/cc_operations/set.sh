#!/bin/bash

source /go/src/github.com/hyperledger/fabric/peer/cc_operations/setGlobals.sh

echo_b "Channel name : "$CHANNEL_NAME

set () {
	PEER=$1
	setGlobals $PEER
	# while 'peer chaincode' command can get the orderer endpoint from the peer (if join was successful),
	# lets supply it directly as we know it using the "-o" option
	if [ -z "$CORE_PEER_TLS_ENABLED" -o "$CORE_PEER_TLS_ENABLED" = "false" ]; then
		peer chaincode invoke -o orderer.example.com:7050 -C $CHANNEL_NAME -n mycc -c '{"Args":["set","'$2'","'$3'"]}' >&log.txt
	else
		peer chaincode invoke -o orderer.example.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n mycc -c '{"Args":["set","'$2'","'$3'"]}' >&log.txt
	fi
	res=$?
	cat log.txt
	verifyResult $res "Invoke execution on PEER$PEER failed "
	echo_g "===================== Invoke transaction on PEER$PEER on channel '$CHANNEL_NAME' is successful ===================== "
	echo
}


if [ "$#" -ne 2 ]; then
	echo_r "=========================== Usage: set variable value =========================== "
    echo_r "e.g. set b 10"
    exit 1
fi

echo_b "Add:\t"$1"("$2")"
set 2 "$1" "$2"

echo
echo_g "================================== Added "$2" to "$1" ================================== "
echo

exit 0
