#!/bin/bash

source "/home/asw/_shared/scripts/common.sh"

mkdir -p ${DOCKER_CERTS}/registry
# Copio i files necessari nella cartella creata
cp ${CERTS_PATH}/{cert,key,ca}.pem ${DOCKER_CERTS}/registry/