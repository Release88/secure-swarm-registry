#!/bin/bash

# DOCKER_REGISTRY=localhost:5000
# my-registry e my-swarm sono degli alias per swarm-1
DOCKER_REGISTRY=${REGISTRY_DOMAIN}:5000

docker build --rm -t ${DOCKER_REGISTRY}/eureka-server-img ./eureka-server
docker build --rm -t ${DOCKER_REGISTRY}/word-img ./word-service
docker build --rm -t ${DOCKER_REGISTRY}/sentence-img ./sentence-service
docker build --rm -t ${DOCKER_REGISTRY}/sentence-zuul-img ./zuul

docker push ${DOCKER_REGISTRY}/eureka-server-img
docker push ${DOCKER_REGISTRY}/word-img
docker push ${DOCKER_REGISTRY}/sentence-img
docker push ${DOCKER_REGISTRY}/sentence-zuul-img






