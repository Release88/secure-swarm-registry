#!/bin/bash

source "/home/asw/_shared/scripts/common.sh"

kubectl apply -f ${ASW_RESOURCES}/registry-pod.yaml
kubectl apply -f ${ASW_RESOURCES}/registry-port.yaml