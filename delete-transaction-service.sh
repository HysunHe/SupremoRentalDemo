#!/bin/sh

if [[ -f ~/app.env ]]
then
    source ~/app.env
fi

nodes=`docker ps -a | grep 'transaction-service0' | wc -l`
if [[ $nodes > 0 ]]
then
        echo "Stopping exist service..."
        docker stop transaction-service0

        echo "Removing exist service..."
        docker rm transaction-service0
fi

for ((i=2; i<=10; i++))
do	

nodes=`docker ps -a | grep "transaction-service$i" | wc -l`
if [[ $nodes > 0 ]]
then
        echo "Stopping exist service..."
        docker stop transaction-service$i

        echo "Removing exist service..."
        docker rm transaction-service$i
fi

echo "Done"

done
