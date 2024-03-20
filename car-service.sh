#!/bin/bash

if [[ -f ~/app.env ]]
then
    source ~/app.env
fi

nodes=`docker ps -a | grep 'car-service-noredis0' | wc -l`
if [[ $nodes > 0 ]]
then
	echo "Stopping exist service..."
	docker stop car-service-noredis0

	echo "Removing exist service..."
	docker rm car-service-noredis0
fi

#image=`docker images | grep 'hysunhe/car-service' | awk '{print $3}'`
#if [[ -n "$image" ]]
#then
#	echo "Removing local image..."
#	docker rmi -f $image
#fi

docker pull hysunhe/car-service

docker run -d \
    --restart=always \
    --name=car-service-noredis0 \
    -v ~/wallet:/app/wallet \
    -e DB_USER="$AJD_USER" \
    -e DB_PASSWORD="$AJD_PASSWORD" \
    -e DB_CONNECTION_STRING="$AJD_TNS_NAME" \
    -e POOL_MIN=23 \
    -e POOL_MAX=23 \
    -e POOL_INCR=1 \
    -p 8084:8080 \
    hysunhe/car-service:latest

echo "Done"

