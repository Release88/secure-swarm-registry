#!/bin/bash

echo 'Starting sentence application as a stack' 

kubectl create secret generic regcred --from-file=.dockerconfigjson=/home/vagrant/.docker/config.json --type=kubernetes.io/dockerconfigjson
kubectl apply -f sentence-stack.yaml
