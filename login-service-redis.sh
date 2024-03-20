#!/bin/bash

if [[ -f ~/app.env ]]
then
    source ~/app.env
fi

nodes=`docker ps -a | grep 'login-service-redis0' | wc -l`
if [[ $nodes > 0 ]]
then
	echo "Stopping exist service..."
	docker stop login-service-redis0

	echo "Removing exist service..."
	docker rm login-service-redis0
fi

#image=`docker images | grep 'hysunhe/login-service-redis' | awk '{print $3}'`
#if [[ -n "$image" ]]
#then
#	echo "Removing local image..."
#	docker rmi -f $image
#fi

docker pull hysunhe/login-service-redis

docker run -d \
    --restart=always \
    --name=login-service-redis0 \
	-e DB_HOST="144.24.107.204" \
	-e DB_PORT="5432" \
	-e DB_NAME="poc_car" \
	-e DB_USER="ouser" \
	-e DB_PASSWORD="BotWelcome123##" \
    -e POOL_MIN=1 \
    -e POOL_MAX=1 \
	-e REDIS_HOST="amaaaaaay5l3z3yabjckinlvpnqhhgssuphzcpak3jlpfbnmjdyokej4le5q-p.redis.ap-mumbai-1.oci.oraclecloud.com" \
	-e REDIS_PORT="6379" \
    -p 8082:8080 \
    hysunhe/login-service-redis:latest

echo "Done"

