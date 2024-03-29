#!/bin/bash

if [[ -f ~/app.env ]]
then
    source ~/app.env
fi

nodes=`sudo docker ps -a | grep 'transaction-service0' | wc -l`
if [[ $nodes > 0 ]]
then
        echo "Stopping exist service..."
        sudo docker stop transaction-service0

        echo "Removing exist service..."
        sudo docker rm transaction-service0
fi

sudo docker pull hysunhe/transaction-service-springboot

sudo docker run -d \
    --restart=always \
    --name=transaction-service0 \
    -e DB_USER="$PG_USER" \
    -e DB_PASS="$PG_PASSWORD" \
    -e RW_DB_CONN_STR="jdbc:postgresql://$PG_ENDPOINT:$PG_PORT/$PG_DBNAME" \
    -e RW_DB_POOL_MIN=2 \
    -e RW_DB_POOL_MAX=10 \
    -e RO_DB_CONN_STR="jdbc:postgresql://$PG_HOST:$PG_PORT/$PG_DBNAME" \
    -e RO_DB_POOL_MIN=2 \
    -e RO_DB_POOL_MAX=10 \
    -p 8083:8080 \
    hysunhe/transaction-service-springboot:latest

echo "Done"
