#!/bin/bash

echo 'Starting sentence application as a stack' 

# inserisco le chiavi e il certificato dello swarm-1
kubectl apply -f sentence-stack.yaml
