#!/bin/bash

source "/home/asw/_shared/scripts/common.sh"

# Creo la cartella in cui salvare i certificati
mkdir -p ${DOCKER_CERTS}

# Copio i certificati
cp ${CERTS_PATH}/{ca,cert,key}.pem ${DOCKER_CERTS}/

# REGISTRY_SSL_PATH corrisponde al percorso alla cartella: 
# /etc/docker/certs.d/my-registry
# come indicato dalla documentazione di docker

mkdir -p ${REGISTRY_SSL_PATH}
# Copio i certificati per accedere al registry protetto
cp ${CERTS_PATH}/registry/cert.pem ${REGISTRY_SSL_PATH}/client.cert
cp ${CERTS_PATH}/registry/key.pem ${REGISTRY_SSL_PATH}/client.key
cp ${CERTS_PATH}/registry/ca.pem ${REGISTRY_SSL_PATH}/ca.crt