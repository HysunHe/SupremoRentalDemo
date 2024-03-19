#!/bin/sh

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
    -e DB_USER="ouser" \
    -e DB_PASSWORD="BotWelcome123##" \
    -e DB_CONNECTION_STRING="jsondb_medium" \
    -e POOL_MIN=1 \
    -e POOL_MAX=1 \
    -e POOL_INCR=1 \
    -e REDIS_HOST="amaaaaaay5l3z3yabjckinlvpnqhhgssuphzcpak3jlpfbnmjdyokej4le5q-p.redis.ap-mumbai-1.oci.oraclecloud.com" \
    -e REDIS_PORT="6379" \
    -p $port:8080 \
    hysunhe/car-service-redis:latest

echo "Done"

done
