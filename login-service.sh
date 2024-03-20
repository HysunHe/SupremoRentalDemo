#!/bin/bash

if [[ -f ~/app.env ]]
then
    source ~/app.env
fi

nodes=`sudo docker ps -a | grep 'login-service-noredis0' | wc -l`
if [[ $nodes > 0 ]]
then
	echo "Stopping exist service..."
	sudo docker stop login-service-noredis0

	echo "Removing exist service..."
	sudo docker rm login-service-noredis0
fi

#image=`sudo docker images | grep 'hysunhe/login-service' | awk '{print $3}'`
#if [[ -n "$image" ]]
#then
#	echo "Removing local image..."
#	sudo docker rmi -f $image
#fi

sudo docker pull hysunhe/login-service

sudo docker run -d \
    --restart=always \
    --name=login-service-noredis0 \
	-e DB_HOST="144.24.107.204" \
	-e DB_PORT="5432" \
	-e DB_NAME="poc_car" \
	-e DB_USER="ouser" \
	-e DB_PASSWORD="BotWelcome123##" \
    	-e POOL_MIN=2 \
    	-e POOL_MAX=2 \
    -p 8085:8080 \
    hysunhe/login-service:latest

echo "Done"

