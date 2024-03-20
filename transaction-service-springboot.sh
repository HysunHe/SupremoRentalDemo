#!/bin/bash

if [[ -f ~/app.env ]]
then
    source ~/app.env
fi

nodes=`sudo docker ps -a | grep 'transaction-service-springboot' | wc -l`
if [[ $nodes > 0 ]]
then
        echo "Stopping exist service..."
        sudo docker stop transaction-service-springboot

        echo "Removing exist service..."
        sudo docker rm transaction-service-springboot
fi

sudo docker pull hysunhe/transaction-service-springboot

sudo docker run -d \
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
