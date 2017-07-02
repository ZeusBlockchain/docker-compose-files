#!/bin/bash

source scripts/header.sh

CHANNEL_NAME="businesschannel"
: ${TIMEOUT:="10"}
COUNTER=1
MAX_RETRY=5
ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/cacerts/ca.example.com-cert.pem

function setGlobals () {
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
	elif [ $1 -eq 2 -o $1 -eq 3 ] ; then # peer 2, 3
		CORE_PEER_LOCALMSPID="Org2MSP"
		CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
		CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
		if [ $1 -eq 2 ]; then
			CORE_PEER_ADDRESS=peer0.org2.example.com:7051
		else
			CORE_PEER_ADDRESS=peer1.org2.example.com:7051
		fi
    fi
	# env |grep CORE
}

function add_map_field () {
    echo
    echo_b "Adding to ""$1"" ""$2"
    insert_map_verify 2 "$1" "$2" "$3"
}

function add_map_fields () {
    while read field; do
        [ -z "$field" ] && continue
        IFS=':' tokens=( $field )
        add_map_field "$1" ${tokens[0]} ${tokens[1]}
    done <$2
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
		peer chaincode invoke -o orderer.example.com:7050 -C $CHANNEL_NAME -n mycc -c '{"Args":["set","'"$2"'","'"$3"'"]}' >&log.txt
	else
		peer chaincode invoke -o orderer.example.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n mycc -c '{"Args":["set","'"$2"'","'"$3"'"]}' >&log.txt
	fi
	res=$?
	cat log.txt
	verifyResult $res "Invoke execution on PEER$PEER failed "
	echo_g "===================== Invoke transaction on PEER$PEER on channel '$CHANNEL_NAME' is successful ===================== "
	echo
}

function set_list () {
	PEER=$1
	setGlobals $PEER
	# while 'peer chaincode' command can get the orderer endpoint from the peer (if join was successful),
	# lets supply it directly as we know it using the "-o" option
	if [ -z "$CORE_PEER_TLS_ENABLED" -o "$CORE_PEER_TLS_ENABLED" = "false" ]; then
		peer chaincode invoke -o orderer.example.com:7050 -C $CHANNEL_NAME -n mycc -c '{"Args":["set_list","'"$2"'","'"$3"'"]}' >&log.txt
	else
		peer chaincode invoke -o orderer.example.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n mycc -c '{"Args":["set_list","'"$2"'","'"$3"'"]}' >&log.txt
	fi
	res=$?
	cat log.txt
	verifyResult $res "Invoke execution on PEER$PEER failed "
	echo_g "===================== Invoke transaction on PEER$PEER on channel '$CHANNEL_NAME' is successful ===================== "
	echo
}


function map_remove () {
	PEER=$1
	setGlobals $PEER
	# while 'peer chaincode' command can get the orderer endpoint from the peer (if join was successful),
	# lets supply it directly as we know it using the "-o" option
	if [ -z "$CORE_PEER_TLS_ENABLED" -o "$CORE_PEER_TLS_ENABLED" = "false" ]; then
		peer chaincode invoke -o orderer.example.com:7050 -C $CHANNEL_NAME -n mycc -c '{"Args":["map_remove","'"$2"'","'"$3"'"]}' >&log.txt
	else
		peer chaincode invoke -o orderer.example.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n mycc -c '{"Args":["map_remove","'"$2"'","'"$3"'"]}' >&log.txt
	fi
	res=$?
	cat log.txt
	verifyResult $res "Invoke execution on PEER$PEER failed "
	echo_g "===================== Invoke transaction on PEER$PEER on channel '$CHANNEL_NAME' is successful ===================== "
	echo
}

function insert_map () {
	PEER=$1
	setGlobals $PEER
	# while 'peer chaincode' command can get the orderer endpoint from the peer (if join was successful),
	# lets supply it directly as we know it using the "-o" option
	if [ -z "$CORE_PEER_TLS_ENABLED" -o "$CORE_PEER_TLS_ENABLED" = "false" ]; then
		peer chaincode invoke -o orderer.example.com:7050 -C $CHANNEL_NAME -n mycc -c '{"Args":["insert_map","'"$2"'","'"$3"'","'"$4"'"]}' >&log.txt
	else
		peer chaincode invoke -o orderer.example.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n mycc -c '{"Args":["insert_map","'"$2"'","'"$3"'","'"$4"'"]}' >&log.txt
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
        peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query","'"$2"'"]}' >&log.txt
        test $? -eq 0 && VALUE=$(cat log.txt | grep "Query Result:" | cut -f 3- -d " ")
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

function chaincodeQueryMap () {
    PEER=$1
	CORRECTVALUE=$3
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
        peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query_map_keys","'"$2"'"]}' >&log.txt
        test $? -eq 0 && VALUE=$(cat log.txt | grep "Query Result:" | cut -f 3- -d " ")
        # test "$VALUE" = "$3" && let rc=0
		IFS=',' read -r -a array1 <<< "$VALUE"
		IFS=',' read -r -a array2 <<< "$CORRECTVALUE"
		sorted1=( $(
			for el in "${array1[@]}"
			do
				echo "$el"
			done | sort) )
		sorted2=( $(
			for el in "${array2[@]}"
			do
				echo "$el"
			done | sort) )
		[ "${sorted1[*]}" == "${sorted2[*]}" ] && rc=0 || rc=1
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

function chaincodeQueryMapField () {
    PEER=$1
	CORRECTVALUE="$4"
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
        peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query_map_field","'"$2"'","'"$3"'"]}' >&log.txt
        test $? -eq 0 && VALUE=$(cat log.txt | grep "Query Result:" | cut -f 3- -d " ")
        test "$VALUE" = "$CORRECTVALUE" && let rc=0
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

function chaincodeQueryMapFieldNoVerification () {
    PEER=$1
    echo_b "===================== Querying on PEER$PEER on channel '$CHANNEL_NAME'... ===================== "
    setGlobals $PEER
    local rc=1
    local starttime=$(date +%s)

    echo_b "Attempting to Query PEER$PEER ...$(($(date +%s)-starttime)) secs"
    peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query_map_field","'"$2"'","'"$3"'"]}' >&log.txt
    test $? -eq 0 && VALUE=$(cat log.txt | grep "Query Result:" | cut -f 3- -d " ")
    echo
    cat log.txt
}


function chaincodeQueryNoVerification () {
    PEER=$1
    echo_b "===================== Querying on PEER$PEER on channel '$CHANNEL_NAME'... ===================== "
    setGlobals $PEER
    local starttime=$(date +%s)

    echo_b "Attempting to Query PEER$PEER ...$(($(date +%s)-starttime)) secs"
    peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query","'"$2"'"]}' >&log.txt
    test $? -eq 0 && VALUE=$(cat log.txt | grep "Query Result:" | cut -f 3- -d " ")
    echo
    cat log.txt
}

function chaincodeQueryList () {
    PEER=$1
    echo_b "===================== Querying on PEER$PEER on channel '$CHANNEL_NAME'... ===================== "
    setGlobals $PEER
	local rc=1
    local starttime=$(date +%s)
	while test "$(($(date +%s)-starttime))" -lt "$TIMEOUT" -a $rc -ne 0
	do
		sleep 3
		echo_b "Attempting to Query PEER$PEER ...$(($(date +%s)-starttime)) secs"
		peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query_list","'"$2"'"]}' >&log.txt
		test $? -eq 0 && VALUE=$(cat log.txt | grep "Query Result:" | cut -f 3- -d " ")
		test "$VALUE" = "$3" && let rc=0
		test "[$VALUE]" = "$3" && let rc=0
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

function chaincodeQueryListNoVerification () {
    PEER=$1
    echo_b "===================== Querying on PEER$PEER on channel '$CHANNEL_NAME'... ===================== "
    setGlobals $PEER
    local starttime=$(date +%s)

    echo_b "Attempting to Query PEER$PEER ...$(($(date +%s)-starttime)) secs"
    peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query_list","'"$2"'"]}' >&log.txt
    test $? -eq 0 && VALUE=$(cat log.txt | grep "Query Result:" | cut -f 3- -d " ")
    echo
    cat log.txt
}

function chaincodeQueryMapNoVerification () {
    PEER=$1
    echo_b "===================== Querying on PEER$PEER on channel '$CHANNEL_NAME'... ===================== "
    setGlobals $PEER
    local starttime=$(date +%s)

    # continue to poll
    # we either get a successful response, or reach TIMEOUT
    echo_b "Attempting to Query PEER$PEER ...$(($(date +%s)-starttime)) secs"
    peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query_map_keys","'"$2"'"]}' >&log.txt
    test $? -eq 0 && VALUE=$(cat log.txt | grep "Query Result:" | cut -f 3- -d " ")
    echo
    cat log.txt
}

function set_list_verify () {
	PEER=$1
	set_list $PEER "$2" "$3"
	chaincodeQueryList $PEER "$2" "$3"
}

function set_verify () {
	PEER=$1
	set $PEER "$2" "$3"
	chaincodeQuery $PEER "$2" "$3"
}

function insert_map_verify () {
	PEER=$1
	insert_map $PEER "$2" "$3" "$4"
	chaincodeQueryMapField $PEER "$2" "$3" "$4"
}
