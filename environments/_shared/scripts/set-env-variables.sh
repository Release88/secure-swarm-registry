#!/bin/bash

STARTING_IP=$1
REGISTRY_DOMAIN=$2
SWARM_DOMAIN=$3
SWARM_NODE_PREFIX=$4
SWARM_NUM=$5


read IP_A IP_B IP_C IP_D <<<"${STARTING_IP//./ }"
IP_PREFIX=${IP_A}.${IP_B}.${IP_C}.
IP_STARTING_NUM=${IP_D}

SSL_DNS="${SWARM_DOMAIN},${REGISTRY_DOMAIN}"

for ((i=1; i<=${SWARM_NUM}; i++))
    do
        CURRENT_NUM=$(($IP_STARTING_NUM+$i))
        CURRENT_IP=${IP_PREFIX}${CURRENT_NUM}
        if [[ $i != 1 ]];
        then
            SSL_IP+=",${CURRENT_IP}"
        else
            SSL_IP+="${CURRENT_IP}"
        fi
        SSL_DNS="${SSL_DNS},${SWARM_NODE_PREFIX}$i"
    done

echo "export STARTING_IP=$1" >> ~/.profile
echo "export REGISTRY_DOMAIN=$2" >> ~/.profile
echo "export SWARM_DOMAIN=$3" >> ~/.profile
echo "export SWARM_NODE_PREFIX=$4" >> ~/.profile
echo "export SWARM_NUM=$5" >> ~/.profile
echo "export SSL_DNS=${SSL_DNS}" >> ~/.profile
echo "export SSL_IP=${SSL_IP}" >> ~/.profile
echo "export IP_PREFIX=${IP_PREFIX}" >> ~/.profile
echo "export IP_STARTING_NUM=${IP_STARTING_NUM}" >> ~/.profile