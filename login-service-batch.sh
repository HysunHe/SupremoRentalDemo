#!/bin/sh

if [[ -f ~/app.env ]]
then
    source ~/app.env
fi

~/SupremoRentalDemo/login-service.sh

port=8400
for ((i=2; i<=10; i++))
do	

port=$((port+1))
echo $port

nodes=`sudo docker ps -a | grep "login-service-noredis$i" | wc -l`
if [[ $nodes > 0 ]]
then
        echo "Stopping exist service..."
        sudo docker stop login-service-noredis$i

        echo "Removing exist service..."
        sudo docker rm login-service-noredis$i
fi

sudo docker run -d \
    --restart=always \
    --name=login-service-noredis$i \
	-e DB_HOST="$PG_HOST" \
	-e DB_PORT="$PG_PORT" \
	-e DB_NAME="$PG_DBNAME" \
	-e DB_USER="$PG_USER" \
	-e DB_PASSWORD="$PG_PASSWORD" \
    -e POOL_MIN=2 \
    -e POOL_MAX=2 \
    -p $port:8080 \
    hysunhe/login-service:latest

echo "Done"

done
