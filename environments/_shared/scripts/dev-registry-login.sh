#!/bin/bash

source "/home/asw/_shared/scripts/common.sh"

docker login -u ${REGISTRY_USER} -p ${REGISTRY_PASSWORD} my-registry:5000

cp /root/.docker/config.json /home/vagrant/.docker/config.json
chown vagrant /home/vagrant/.docker/config.json