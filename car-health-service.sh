#!/bin/bash

if [[ -f ~/app.env ]]
then
    source ~/app.env
fi

nodes=`sudo docker ps -a | grep 'car-health-service0' | wc -l`
if [[ $nodes > 0 ]]
then
	echo "Stopping exist service..."
	sudo docker stop car-health-service0

	echo "Removing exist service..."
	sudo docker rm car-health-service0
fi

#image=`sudo docker images | grep 'hysunhe/car-health-service' | awk '{print $3}'`
#if [[ -n "$image" ]]
#then
#	echo "Removing local image..."
#	sudo docker rmi -f $image
#fi

sudo docker pull hysunhe/car-health-service

sudo docker run -d \
    --restart=always \
    --name=car-health-service0 \
    -v ~/.oci/:/app/oci/ \
    -e REGION="ap-mumbai-1" \
    -e COMPARTMENT="ocid1.compartment.oc1..aaaaaaaarqb2weqk733pm2xqgliwgi6nfm6kajcq7zqgetiavabxmryqxpeq" \
    -e OCI_CONFIG_FILE="/app/oci/config" \
    -e OCI_CONFIG_PROFILE="DEFAULT" \
    -p 8086:8080 \
    hysunhe/car-health-service:latest

echo "Done"


