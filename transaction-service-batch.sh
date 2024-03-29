#!/bin/sh

if [[ -f ~/app.env ]]
then
    source ~/app.env
fi

~/SupremoRentalDemo/transaction-service.sh

port=8600
for ((i=2; i<=3; i++))
do	

port=$((port+1))
echo $port

nodes=`sudo docker ps -a | grep "transaction-service$i" | wc -l`
if [[ $nodes > 0 ]]
then
        echo "Stopping exist service..."
        sudo docker stop transaction-service$i

        echo "Removing exist service..."
        sudo docker rm transaction-service$i
fi

sudo docker run -d \
    --restart=always \
    --name=transaction-service$i \
    -e DB_USER="$PG_USER" \
    -e DB_PASS="$PG_PASSWORD" \
    -e RW_DB_CONN_STR="jdbc:postgresql://$PG_ENDPOINT:$PG_PORT/$PG_DBNAME" \
    -e RW_DB_POOL_MIN=2 \
    -e RW_DB_POOL_MAX=10 \
    -e RO_DB_CONN_STR="jdbc:postgresql://$PG_HOST:$PG_PORT/$PG_DBNAME" \
    -e RO_DB_POOL_MIN=2 \
    -e RO_DB_POOL_MAX=10 \
    -p $port:8080 \
    hysunhe/transaction-service-springboot:latest

echo "Done"

done
