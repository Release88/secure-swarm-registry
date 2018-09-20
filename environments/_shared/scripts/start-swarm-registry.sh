#!/bin/bash

# https://docs.docker.com/registry/deploying/

echo 'Starting private registry as a service -> my-registry:5000' 

# nell'ambiente docker-swarm, il registry puo' essere acceduto su my-registry:5000 
# my-registry e' un alias per swarm-1
# inoltre, anche my-swarm e' un alias per swarm-1 

# my-registry:5000 e' abilitato come registry insicuro grazie all'uso del 
# file di configurazione ${ASW_RESOURCES}/docker.service.d/override.conf 

# si assicura che la cartella /home/asw/data/my-registry sia stata creata 

mkdir -p /home/asw/data/my-registry

#docker service create --name my-registry \
#                      --publish 5000:5000 \
#					  --restart-condition on-failure \
#					  --mount type=bind,src=/home/asw/data/my-registry,dst=/var/lib/registry \
#					  registry:2 


# modifico il comando inserendo la cartella dei certificati ed il file di configurazione

docker service create --name ${REGISTRY_DOMAIN} \
                      --publish 5000:5000 \
					  --restart-condition on-failure \
					  --mount type=bind,src=/home/asw/data/my-registry,dst=/var/lib/registry \
					  --mount type=bind,src=/home/vagrant/.docker/registry,dst=/certs \
					  --mount type=bind,src=/home/asw/_shared/resources/registry-config.yml,dst=/etc/docker/registry/config.yml \
					  registry:2 