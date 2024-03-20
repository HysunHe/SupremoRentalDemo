#!/bin/bash

if [[ -f ~/app.env ]]
then
    source ~/app.env
fi

nodes=`docker ps -a | grep 'transaction-service-springboot' | wc -l`
if [[ $nodes > 0 ]]
then
        echo "Stopping exist service..."
        docker stop transaction-service-springboot

        echo "Removing exist service..."
        docker rm transaction-service-springboot
fi

docker pull hysunhe/transaction-service-springboot

docker run -d \
    --restart=always \
    --name=transaction-service-springboot \
    -p 8801:8080 \
    -e DB_CONN_STR="jdbc:postgresql://144.24.107.204:5432/poc_car" \
    -e DB_USER="ouser" \
    -e DB_PASS="BotWelcome123##" \
    -e DB_POOL_MIN=50 \
    -e DB_POOL_MAX=50 \
    hysunhe/transaction-service-springboot:latest

echo "Done"
