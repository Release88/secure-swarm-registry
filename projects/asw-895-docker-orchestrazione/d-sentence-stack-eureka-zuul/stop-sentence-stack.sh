#!/bin/bash

echo 'Halting sentence application as a stack' 

# DOCKER_REGISTRY=localhost:5000
# my-registry e my-swarm sono degli alias per swarm-1
DOCKER_SWARM=tcp://swarm-1:2376

# inserisco le chiavi e il certificato dello swarm-1
docker --host ${DOCKER_SWARM} --tlsverify --tlscacert /home/vagrant/.docker/ca.pem --tlscert /home/vagrant/.docker/cert.pem --tlskey /home/vagrant/.docker/key.pem stack rm sentence
