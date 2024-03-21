#!/bin/bash

if [[ -f ~/app.env ]]
then
    source ~/app.env
fi

nodes=`sudo docker ps -a | grep 'car-service-noredis0' | wc -l`
if [[ $nodes > 0 ]]
then
	echo "Stopping exist service..."
	sudo docker stop car-service-noredis0

	echo "Removing exist service..."
	sudo docker rm car-service-noredis0
fi

sudo docker pull hysunhe/car-service

sudo docker run -d \
    --restart=always \
    --name=car-service-noredis0 \
    -v ~/wallet:/app/wallet \
    -e DB_USER="$AJD_USER" \
    -e DB_PASSWORD="$AJD_PASSWORD" \
    -e DB_CONNECTION_STRING="$AJD_TNS_NAME" \
    -e POOL_MIN=2 \
    -e POOL_MAX=10 \
    -e POOL_INCR=2 \
    -p 8084:8080 \
    hysunhe/car-service:latest

echo "Done"

