#!/bin/bash

# da eseguire sul nodo swarm-1 
# richiede che su ciascun nodo dello swarm sia abilitato l'accesso remoto 

echo "Creating swarm on swarm-1" 

docker swarm init --advertise-addr 10.11.1.71

SWARM_TOKEN=$(docker swarm join-token -q worker)

echo "Swarm token: ${SWARM_TOKEN}"
echo "Adding swarm-2 and swarm-3" 

# inserisco nel comando le chiavi e il certificato
docker --host swarm-2:2376 --tlsverify --tlscacert /home/vagrant/.docker/swarm-2-ca.pem --tlscert /home/vagrant/.docker/swarm-2-cert.pem --tlskey /home/vagrant/.docker/swarm-2-key.pem swarm join --token ${SWARM_TOKEN} swarm-1:2377
docker --host swarm-3:2376 --tlsverify --tlscacert /home/vagrant/.docker/swarm-3-ca.pem --tlscert /home/vagrant/.docker/swarm-3-cert.pem --tlskey /home/vagrant/.docker/swarm-3-key.pem swarm join --token ${SWARM_TOKEN} swarm-1:2377