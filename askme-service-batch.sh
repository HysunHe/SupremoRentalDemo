#!/bin/bash

if [[ -f ~/app.env ]]
then
    source ~/app.env
fi

sudo docker pull hysunhe/askme-service

port=8700
for ((i=2; i<=3; i++))
do	

port=$((port+1))
echo $port

nodes=`sudo docker ps -a | grep "askme-service$i" | wc -l`
if [[ $nodes > 0 ]]
then
        echo "Stopping exist service..."
        sudo docker stop askme-service$i

        echo "Removing exist service..."
        sudo docker rm askme-service$i
fi

sudo docker run -d \
    --restart=always \
    --name=askme-service$i \
    -e OS_USER="$OS_USER" \
    -e OS_PASS="$OS_PASSWORD" \
    -e OS_ENDPOINT="$OS_ENDPOINT" \
    -p $port:8080 \
    hysunhe/askme-service:latest

echo "Done"

done