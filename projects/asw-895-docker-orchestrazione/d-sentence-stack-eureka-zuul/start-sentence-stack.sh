#!/bin/bash

echo 'Starting sentence application as a stack' 

# DOCKER_REGISTRY=localhost:5000
# my-registry e my-swarm sono degli alias per swarm-1
DOCKER_SWARM=tcp://my-swarm:2376

# inserisco le chiavi e il certificato dello swarm-1
docker --host ${DOCKER_SWARM} --tlsverify --tlscacert /home/vagrant/.docker/ca.pem --tlscert /home/vagrant/.docker/cert.pem --tlskey /home/vagrant/.docker/key.pem stack deploy --with-registry-auth --compose-file docker-stack-sentence.yml sentence
