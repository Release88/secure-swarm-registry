#!/bin/bash

source "/home/asw/_shared/scripts/common.sh"

mkdir -p /home/asw/data/my-registry

docker run --name temp-registry \
        --entrypoint htpasswd  registry:2 \
		-Bbn ${REGISTRY_USER} ${REGISTRY_PASSWORD} > /home/asw/_shared/resources/htpasswd