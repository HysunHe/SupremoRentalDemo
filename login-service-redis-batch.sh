#!/bin/sh

if [[ -f ~/app.env ]]
then
    source ~/app.env
fi

~/SupremoRentalDemo/login-service-redis.sh

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
	-e DB_HOST="$PG_HOST" \
	-e DB_PORT="$PG_PORT" \
	-e DB_NAME="$PG_DBNAME" \
	-e DB_USER="$PG_USER" \
	-e DB_PASSWORD="$PG_PASSWORD" \
    -e POOL_MIN=1 \
    -e POOL_MAX=1 \
    -e REDIS_HOST="$REDIS_HOST" \
    -e REDIS_PORT="$REDIS_PORT" \
    -p $port:8080 \
    hysunhe/login-service-redis:latest

echo "Done"

done
