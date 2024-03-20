#!/bin/bash

if [[ -f ~/app.env ]]
then
    source ~/app.env
fi

nodes=`sudo docker ps -a | grep 'login-service-redis0' | wc -l`
if [[ $nodes > 0 ]]
then
	echo "Stopping exist service..."
	sudo docker stop login-service-redis0

	echo "Removing exist service..."
	sudo docker rm login-service-redis0
fi

sudo docker pull hysunhe/login-service-redis

sudo docker run -d \
    --restart=always \
    --name=login-service-redis0 \
	-e DB_HOST="$PG_HOST" \
	-e DB_PORT="$PG_PORT" \
	-e DB_NAME="$PG_DBNAME" \
	-e DB_USER="$PG_USER" \
	-e DB_PASSWORD="$PG_PASSWORD" \
    -e POOL_MIN=1 \
    -e POOL_MAX=1 \
    -e REDIS_HOST="$REDIS_HOST" \
    -e REDIS_PORT="$REDIS_PORT" \
    -p 8082:8080 \
    hysunhe/login-service-redis:latest

echo "Done"

