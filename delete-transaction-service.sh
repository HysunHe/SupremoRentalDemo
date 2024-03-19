#!/bin/sh

nodes=`sudo docker ps -a | grep 'transaction-service0' | wc -l`
if [[ $nodes > 0 ]]
then
        echo "Stopping exist service..."
        sudo docker stop transaction-service0

        echo "Removing exist service..."
        sudo docker rm transaction-service0
fi

for ((i=2; i<=10; i++))
do	

nodes=`sudo docker ps -a | grep "transaction-service$i" | wc -l`
if [[ $nodes > 0 ]]
then
        echo "Stopping exist service..."
        sudo docker stop transaction-service$i

        echo "Removing exist service..."
        sudo docker rm transaction-service$i
fi

echo "Done"

done
