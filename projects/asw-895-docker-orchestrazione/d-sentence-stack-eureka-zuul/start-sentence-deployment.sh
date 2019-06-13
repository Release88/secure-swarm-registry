#!/bin/bash

echo 'Starting sentence application as a stack' 

kubectl create secret generic regcred --from-file=.dockerconfigjson=/home/vagrant/.docker/config.json --type=kubernetes.io/dockerconfigjson
kubectl apply -f sentence-stack.yaml
kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.7.3/manifests/metallb.yaml
kubectl apply -f /home/asw/_shared/resources/load-balancer-configuration.yaml