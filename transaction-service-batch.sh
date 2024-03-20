#!/bin/sh

if [[ -f ~/app.env ]]
then
    source ~/app.env
fi

./transaction-service.sh

port=8600
for ((i=2; i<=10; i++))
do	

port=$((port+1))
echo $port

nodes=`docker ps -a | grep "transaction-service$i" | wc -l`
if [[ $nodes > 0 ]]
then
        echo "Stopping exist service..."
        docker stop transaction-service$i

        echo "Removing exist service..."
        docker rm transaction-service$i
fi

docker run -d \
    --restart=always \
    --name=transaction-service$i \
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
    -p $port:8080 \
    hysunhe/transaction-service:latest

echo "Done"

done
