#!/bin/bash

# da eseguire sul nodo swarm-1 
# richiede che su ciascun nodo dello swarm sia abilitato l'accesso remoto 

echo "Creating swarm on swarm-1" 

docker swarm init --advertise-addr ${IP_PREFIX}$(($IP_STARTING_NUM+1))

SWARM_TOKEN=$(docker swarm join-token -q worker)

echo "Swarm token: ${SWARM_TOKEN}"
echo "Adding other swarm nodes" 

# inserisco nel comando le chiavi e il certificato
for ((i=2; i<=${SWARM_NUM}; i++))
    do
        docker --host swarm-${i}:2376 --tlsverify --tlscacert /home/vagrant/.docker/ca.pem --tlscert /home/vagrant/.docker/cert.pem --tlskey /home/vagrant/.docker/key.pem swarm join --token ${SWARM_TOKEN} swarm-1:2377
    done
