sudo docker kill $(sudo docker ps -q) &&
echo "Killed" &&
sudo docker rm $(sudo docker ps -aq) &&
sudo docker rmi -f `sudo docker images|grep mycc-1.0|awk '{print $3}'`
echo "Removed" &&
sudo docker-compose -f docker-compose-2orgs-4peers.yaml up -d &&
echo "Containers up" &&
echo "Starting cli.." &&
sudo docker exec -it fabric-cli bash
