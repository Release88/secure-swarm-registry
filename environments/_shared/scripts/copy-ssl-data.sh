#!/bin/bash

source "/home/asw/_shared/scripts/common.sh"

mkdir -p ${DOCKER_CERTS}
mkdir -p ${REGISTRY_SSL_PATH}
# Copio i certificati per accedere al registry protetto
cp ${CERTS_PATH}/registry/cert.pem ${REGISTRY_SSL_PATH}/client.cert
cp ${CERTS_PATH}/registry/key.pem ${REGISTRY_SSL_PATH}/client.key
cp ${CERTS_PATH}/registry/ca.pem ${REGISTRY_SSL_PATH}/ca.crt