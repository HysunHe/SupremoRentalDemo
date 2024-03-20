#!/bin/bash

if [[ -f ~/app.env ]]
then
    source ~/app.env
fi

nodes=`docker ps -a | grep 'car-health-service0' | wc -l`
if [[ $nodes > 0 ]]
then
	echo "Stopping exist service..."
	docker stop car-health-service0

	echo "Removing exist service..."
	docker rm car-health-service0
fi

#image=`docker images | grep 'hysunhe/car-health-service' | awk '{print $3}'`
#if [[ -n "$image" ]]
#then
#	echo "Removing local image..."
#	docker rmi -f $image
#fi

docker pull hysunhe/car-health-service

docker run -d \
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


