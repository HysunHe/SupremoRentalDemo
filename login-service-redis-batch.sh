#!/bin/sh

./login-service-redis.sh

port=8500
for ((i=2; i<=10; i++))
do	

port=$((port+1))
echo $port

nodes=`sudo docker ps -a | grep "login-service-redis$i" | wc -l`
if [[ $nodes > 0 ]]
then
        echo "Stopping exist service..."
        sudo docker stop login-service-redis$i

        echo "Removing exist service..."
        sudo docker rm login-service-redis$i
fi

sudo docker run -d \
    --restart=always \
    --name=login-service-redis$i \
	-e DB_HOST="144.24.107.204" \
	-e DB_PORT="5432" \
	-e DB_NAME="poc_car" \
	-e DB_USER="ouser" \
	-e DB_PASSWORD="BotWelcome123##" \
    -e POOL_MIN=1 \
    -e POOL_MAX=1 \
	-e REDIS_HOST="amaaaaaay5l3z3yabjckinlvpnqhhgssuphzcpak3jlpfbnmjdyokej4le5q-p.redis.ap-mumbai-1.oci.oraclecloud.com" \
	-e REDIS_PORT="6379" \
    -p $port:8080 \
    hysunhe/login-service-redis:latest

echo "Done"

done
