#!/bin/bash

source scripts/header.sh

CHANNEL_NAME="businesschannel"
: ${TIMEOUT:="10"}
COUNTER=1
MAX_RETRY=5
ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/cacerts/ca.example.com-cert.pem

echo_b "Channel name : "$CHANNEL_NAME

verifyResult () {
    if [ $1 -ne 0 ] ; then
        echo_b "!!!!!!!!!!!!!!! "$2" !!!!!!!!!!!!!!!!"
                echo_r "================== ERROR !!! FAILED to execute End-2-End Scenario =================="
        echo
        exit 1
    fi
}

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

chaincodeInvoke () {
    PEER=$1
    setGlobals $PEER
    # while 'peer chaincode' command can get the orderer endpoint from the peer (if join was successful),
    # lets supply it directly as we know it using the "-o" option
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

echo_b "Invoking org1/peer0..."
if [ -z "$4" ]; then
    chaincodeInvoke 2 "$1" "$2" "$3"
else
    chaincodeInvoke 2 a b 10
fi

exit 0
