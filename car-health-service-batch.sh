#!/bin/sh

if [[ -f ~/app.env ]]
then
    source ~/app.env
fi

source ~/app.env

./car-health-service.sh

port=8700
for ((i=2; i<=10; i++))
do	

port=$((port+1))
echo $port

nodes=`docker ps -a | grep "car-health-service$i" | wc -l`
if [[ $nodes > 0 ]]
then
        echo "Stopping exist service..."
        docker stop car-health-service$i

        echo "Removing exist service..."
        docker rm car-health-service$i
fi

docker run -d \
    --restart=always \
    --name=car-health-service$i \
    -v ~/.oci/:/app/oci/ \
    -e REGION="ap-mumbai-1" \
    -e COMPARTMENT="ocid1.compartment.oc1..aaaaaaaarqb2weqk733pm2xqgliwgi6nfm6kajcq7zqgetiavabxmryqxpeq" \
    -e OCI_CONFIG_FILE="/app/oci/config" \
    -e OCI_CONFIG_PROFILE="DEFAULT" \
    -p $port:8080 \
    hysunhe/car-health-service:latest

echo "Done"

done
