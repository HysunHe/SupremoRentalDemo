#!/bin/bash

if [[ -f ~/app.env ]]
then
    source ~/app.env
fi

region=$NOSQL_REGION
if [[ -z $region ]]
then
    region=$REGION
fi

nodes=`sudo docker ps -a | grep 'car-health-service0' | wc -l`
if [[ $nodes > 0 ]]
then
	echo "Stopping exist service..."
	sudo docker stop car-health-service0

	echo "Removing exist service..."
	sudo docker rm car-health-service0
fi

sudo docker pull hysunhe/car-health-service

sudo docker run -d \
    --restart=always \
    --name=car-health-service0 \
    -v ~/.oci_docker/:/app/oci/ \
    -e REGION="$region" \
    -e COMPARTMENT="$NOSQL_COMPARTMENT" \
    -e OCI_CONFIG_FILE="/app/oci/config" \
    -e OCI_CONFIG_PROFILE="DEFAULT" \
    -p 8086:8080 \
    hysunhe/car-health-service:latest

echo "Done"


