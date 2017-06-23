#! /bin/bash

# echo "replace configtx.yaml and crypto-config.yaml"
# cp ./peer/example2/configtx.yaml ./peer
# cp ./peer/example2/crypto-config.yaml ./peer

# echo "replace auto-test script "
# cp ./peer/example2/new-channel-auto-test-5-peers.sh ./peer/scripts

# echo "replace configtx.yaml"
# cp ./peer/configtx.yaml /etc/hyperledger/fabric

echo "Generate new certificates"

# cryptogen generate --config=./peer/crypto-config.yaml --output ./peer/crypto
cryptogen generate --config=/etc/hyperledger/fabric/crypto-config.yaml --output ./crypto

echo "Generate new certificates"
# configtxgen -profile ThreeOrgsOrdererGenesis -outputBlock ./peer/channel-artifacts/orderer_genesis.block
configtxgen -profile ThreeOrgsOrdererGenesis -outputBlock ./channel-artifacts/orderer_genesis.block

echo "Create the configuration tx"
# CHANNEL_NAME=newchannel
CHANNEL_NAME=businesschannel
# configtxgen -profile ThreeOrgsChannel -outputCreateChannelTx ./peer/channel-artifacts/channel.tx -channelID ${CHANNEL_NAME}
configtxgen -profile ThreeOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID ${CHANNEL_NAME}

echo "Define the anchor peer for Zeus on the channel"
# configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./peer/channel-artifacts/ZeusMSPanchors.tx -channelID ${CHANNEL_NAME} -asOrg ZeusMSP
# configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./peer/channel-artifacts/TrusteesMSPanchors.tx -channelID ${CHANNEL_NAME} -asOrg TrusteesMSP
# configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./peer/channel-artifacts/MixersMSPanchors.tx -channelID ${CHANNEL_NAME} -asOrg MixersMSP
configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/ZeusMSPanchors.tx -channelID ${CHANNEL_NAME} -asOrg ZeusMSP
configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/TrusteesMSPanchors.tx -channelID ${CHANNEL_NAME} -asOrg TrusteesMSP
configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/MixersMSPanchors.tx -channelID ${CHANNEL_NAME} -asOrg MixersMSP

