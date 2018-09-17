#!/bin/bash

source "/home/asw/_shared/scripts/common.sh"

# Creo la cartella in cui salvare i certificati
mkdir -p ${DOCKER_CERTS}/server-certs

# Copio i certificati
cp ${CERTS_PATH}/swarm-$1-{ca,server-cert,server-key}.pem ${DOCKER_CERTS}/server-certs/
mv ${DOCKER_CERTS}/server-certs/swarm-$1-ca.pem ${DOCKER_CERTS}/server-certs/ca.pem
mv ${DOCKER_CERTS}/server-certs/swarm-$1-server-cert.pem ${DOCKER_CERTS}/server-certs/server-cert.pem
mv ${DOCKER_CERTS}/server-certs/swarm-$1-server-key.pem ${DOCKER_CERTS}/server-certs/server-key.pem


# Creo la cartella in cui salvare le chiavi da incorporare nel servizio my-registry
mkdir -p ${DOCKER_CERTS}/registry
# Copio i files necessari nella cartella creata
cp ${CERTS_PATH}/my-registry-{server-cert,server-key,ca,cert}.pem ${DOCKER_CERTS}/registry/