sudo docker kill $(sudo docker ps -q) &&
echo "Killed" &&
sudo docker rm $(sudo docker ps -aq) &&
echo "Removed" &&
sudo docker-compose -f docker-compose-2orgs-4peers.yaml up -d &&
echo "Containers up" &&
sudo docker cp e2e_cli/examples/chaincode/go/chaincode_example02/chaincode_example02.go fabric-cli:/go/src/github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02 &&
sudo docker cp e2e_cli/examples/chaincode/go/chaincode_example02/chaincode_example02.go peer1.org2.example.com:/go/src/github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02 &&
sudo docker cp e2e_cli/examples/chaincode/go/chaincode_example02/chaincode_example02.go peer0.org1.example.com:/go/src/github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02 &&
sudo docker cp e2e_cli/examples/chaincode/go/chaincode_example02/chaincode_example02.go peer1.org1.example.com:/go/src/github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02 &&
sudo docker cp e2e_cli/examples/chaincode/go/chaincode_example02/chaincode_example02.go peer0.org2.example.com:/go/src/github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02 &&
sudo docker cp e2e_cli/examples/chaincode/go/chaincode_example02/chaincode_example02.go orderer.example.com:/go/src/github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02  &&
echo "Copied chaincode" &&
echo "Starting cli.." &&
sudo docker exec -it fabric-cli bash
