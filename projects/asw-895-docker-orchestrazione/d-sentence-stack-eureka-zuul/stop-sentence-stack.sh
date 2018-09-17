#!/bin/bash

echo 'Halting sentence application as a stack' 

# DOCKER_REGISTRY=localhost:5000
# my-registry e my-swarm sono degli alias per swarm-1
DOCKER_SWARM=tcp://swarm-1:2376

# inserisco le chiavi e il certificato dello swarm-1
docker --host ${DOCKER_SWARM} --tlsverify --tlscacert /home/vagrant/.docker/swarm-1-ca.pem --tlscert /home/vagrant/.docker/swarm-1-cert.pem --tlskey /home/vagrant/.docker/swarm-1-key.pem stack rm sentence
