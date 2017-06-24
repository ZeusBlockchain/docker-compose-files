#!/bin/bash

source scripts/header.sh

CHANNEL_NAME="businesschannel"
: ${TIMEOUT:="10"}
COUNTER=1
MAX_RETRY=5
ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/cacerts/ca.example.com-cert.pem

function setGlobals () {
    if [ $1 -eq 0 -o $1 -eq 1 ] ; then
        CORE_PEER_LOCALMSPID="ZeusMSP"
        CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/zeus.example.com/peers/peer0.zeus.example.com/tls/ca.crt
        CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/zeus.example.com/users/Admin@zeus.example.com/msp
        if [ $1 -eq 0 ]; then
            CORE_PEER_ADDRESS=peer0.zeus.example.com:7051
        else
            CORE_PEER_ADDRESS=peer1.zeus.example.com:7051
            CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/zeus.example.com/users/Admin@zeus.example.com/msp
        fi
    elif [ $1 -eq 2 -o $1 -eq 3 ] ; then # peer 2, 3
        CORE_PEER_LOCALMSPID="TrusteesMSP"
        CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/trustees.example.com/peers/peer0.trustees.example.com/tls/ca.crt
        CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/trustees.example.com/users/Admin@trustees.example.com/msp
        if [ $1 -eq 2 ]; then
            CORE_PEER_ADDRESS=peer0.trustees.example.com:7051
        else
            CORE_PEER_ADDRESS=peer1.trustees.example.com:7051
        fi
    else # peer 4, 5
        CORE_PEER_LOCALMSPID="MixersMSP"
        CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mixers.example.com/peers/peer0.mixers.example.com/tls/ca.crt
        CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mixers.example.com/users/Admin@mixers.example.com/msp
        if [ $1 -eq 4 ]; then
            CORE_PEER_ADDRESS=peer0.mixers.example.com:7051
        else
            CORE_PEER_ADDRESS=peer1.mixers.example.com:7051
        fi
    fi
    # env |grep CORE
}

function verifyResult () {
    if [ $1 -ne 0 ] ; then
        echo_b "!!!!!!!!!!!!!!! "$2" !!!!!!!!!!!!!!!!"
        echo_r "================== ERROR !!! FAILED to execute End-2-End Scenario =================="
        echo
        exit 1
    fi
}

function set () {
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

function set_verify () {
    PEER=$1
    set $PEER "$2" "$3"
    chaincodeQuery $PEER "$2" "$3"
}
