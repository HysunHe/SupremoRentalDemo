#!/bin/bash

nodes=`sudo docker ps -a | grep 'transaction-service0' | wc -l`
if [[ $nodes > 0 ]]
then
	echo "Stopping exist service..."
	sudo docker stop transaction-service0

	echo "Removing exist service..."
	sudo docker rm transaction-service0
fi

#image=`sudo docker images | grep 'hysunhe/transaction-service' | awk '{print $3}'`
#if [[ -n "$image" ]]
#then
#	echo "Removing local image..."
#	sudo docker rmi -f $image
#fi

sudo docker pull hysunhe/transaction-service

echo "Downloading latest image and run it..."

sudo docker run -d \
    --restart=always \
    --name=transaction-service0 \
    -e DB_HOST="144.24.107.204" \
    -e DB_HOST_WRITE="10.0.1.71" \
    -e DB_PORT="5432" \
    -e DB_NAME="poc_car" \
    -e DB_USER="ouser" \
    -e DB_PASSWORD="BotWelcome123##" \
    -e POOL_MIN=2 \
    -e POOL_MAX=2 \
    -e POOL_MIN_WRITE=1 \
    -e POOL_MIN_WRITE=1 \
    -p 8083:8080 \
    hysunhe/transaction-service:latest

echo "Done"

