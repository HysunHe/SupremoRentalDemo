#!/bin/sh

if [[ -f ~/app.env ]]
then
    source ~/app.env
fi

region=$NOSQL_REGION
if [[ -z $region ]]
then
    region=$REGION
fi

~/SupremoRentalDemo/car-health-service.sh

port=8700
for ((i=2; i<=10; i++))
do	

port=$((port+1))
echo $port

nodes=`sudo docker ps -a | grep "car-health-service$i" | wc -l`
if [[ $nodes > 0 ]]
then
        echo "Stopping exist service..."
        sudo docker stop car-health-service$i

        echo "Removing exist service..."
        sudo docker rm car-health-service$i
fi

sudo docker run -d \
    --restart=always \
    --name=car-health-service$i \
    -v ~/.oci/:/app/oci/ \
    -e REGION="$region" \
    -e COMPARTMENT="$NOSQL_COMPARTMENT" \
    -e OCI_CONFIG_FILE="/app/oci/config" \
    -e OCI_CONFIG_PROFILE="DEFAULT" \
    -p $port:8080 \
    hysunhe/car-health-service:latest

echo "Done"

done
