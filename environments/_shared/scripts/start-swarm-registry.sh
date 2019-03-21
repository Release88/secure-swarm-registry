#!/bin/bash

# https://docs.docker.com/registry/deploying/

echo 'Starting private registry as a service -> my-registry:5000' 

source "/home/asw/_shared/scripts/common.sh"

# nell'ambiente docker-swarm, il registry puo' essere acceduto su my-registry:5000 
# my-registry e' un alias per swarm-1
# inoltre, anche my-swarm e' un alias per swarm-1 

# my-registry:5000 e' abilitato come registry insicuro grazie all'uso del 
# file di configurazione ${ASW_RESOURCES}/docker.service.d/override.conf 

# si assicura che la cartella /home/asw/data/my-registry sia stata creata 

mkdir -p /home/asw/data/my-registry

docker run --name temp-registry \
        --entrypoint htpasswd  registry:2 \
		-Bbn ${REGISTRY_USER} ${REGISTRY_PASSWORD} > /home/asw/_shared/resources/htpasswd

docker service create --name ${REGISTRY_DOMAIN} \
                      --publish 5000:5000 \
					  --restart-condition on-failure \
					  --mount type=bind,src=/home/asw/data/my-registry,dst=/var/lib/registry \
					  --mount type=bind,src=/home/vagrant/.docker/registry,dst=/certs \
					  --mount type=bind,src=/home/asw/_shared/resources/registry-config.yml,dst=/etc/docker/registry/config.yml \
					  --mount type=bind,src=/home/asw/_shared/resources/htpasswd,dst=/auth/htpasswd \
					  registry:2 


# login al repository
docker login -u ${REGISTRY_USER} -p ${REGISTRY_PASSWORD} my-registry:5000

cp /root/.docker/config.json /home/vagrant/.docker/config.json
chown vagrant /home/vagrant/.docker/config.json