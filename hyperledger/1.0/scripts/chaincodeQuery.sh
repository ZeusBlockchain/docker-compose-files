#!/bin/bash

source scripts/header.sh

CHANNEL_NAME="businesschannel"
: ${TIMEOUT:="10"}
COUNTER=1
MAX_RETRY=5
ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/cacerts/ca.example.com-cert.pem

echo_b "Channel name : "$CHANNEL_NAME


setGlobals () {

	if [ $1 -eq 0 -o $1 -eq 1 ] ; then
		CORE_PEER_LOCALMSPID="Org1MSP"
		CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
		CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
		if [ $1 -eq 0 ]; then
			CORE_PEER_ADDRESS=peer0.org1.example.com:7051
		else
			CORE_PEER_ADDRESS=peer1.org1.example.com:7051
			CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
		fi
	else
		CORE_PEER_LOCALMSPID="Org2MSP"
		CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
		CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
		if [ $1 -eq 2 ]; then
			CORE_PEER_ADDRESS=peer0.org2.example.com:7051
		else
			CORE_PEER_ADDRESS=peer1.org2.example.com:7051
		fi
	fi

	env |grep CORE
}

chaincodeQuery () {
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

chaincodeQueryNoVerification () {
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
if [ -z "$2" ]
  then
	  echo_b "Querying chaincode on org1/peer0..."
	  chaincodeQueryNoVerification 2 "$1"
  else
	  echo_b "Querying chaincode on org1/peer0..."
	  chaincodeQuery 2 "$1" "$2"
fi

exit 0
