#!/bin/sh

if [[ -f ~/app.env ]]
then
    source ~/app.env
fi

./car-service-redis.sh

port=8300
for ((i=2; i<=10; i++))
do	

port=$((port+1))
echo $port

nodes=`sudo docker ps -a | grep "car-service-redis$i" | wc -l`
if [[ $nodes > 0 ]]
then
        echo "Stopping exist service..."
        sudo docker stop car-service-redis$i

        echo "Removing exist service..."
        sudo docker rm car-service-redis$i
fi

sudo docker run -d \
    --restart=always \
    --name=car-service-redis$i \
    -v ~/wallet:/app/wallet \
    -e DB_USER="$AJD_USER" \
    -e DB_PASSWORD="$AJD_PASSWORD" \
    -e DB_CONNECTION_STRING="$AJD_TNS_NAME" \
    -e POOL_MIN=1 \
    -e POOL_MAX=1 \
    -e POOL_INCR=1 \
    -e REDIS_HOST="$REDIS_HOST" \
    -e REDIS_PORT="$REDIS_PORT" \
    -p $port:8080 \
    hysunhe/car-service-redis:latest

echo "Done"

done
