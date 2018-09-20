#!/bin/bash

# dove vengono montate le risorse e i download condivisi 
ASW_HOME=/home/asw 
HOME_PATH=/home/vagrant
ASW_DOWNLOADS=${ASW_HOME}/_shared/downloads
ASW_RESOURCES=${ASW_HOME}/_shared/resources
CERTS_PATH=${ASW_RESOURCES}/certs
DOCKER_CERTS=${HOME_PATH}/.docker
REGISTRY_SSL_PATH=/etc/docker/certs.d/my-registry:5000
STARTING_IP=${STARTING_IP}
REGISTRY_DOMAIN=${REGISTRY_DOMAIN}
SWARM_DOMAIN=${SWARM_DOMAIN}
SWARM_NODE_PREFIX=${SWARM_NODE_PREFIX}
SSL_DNS=${SSL_DNS}
SSL_IP=${SSL_IP}
SSL_SUBJECT=${SWARM_DOMAIN}

#echo SSL_DNS=${SSL_DNS}
#echo SSL_IP=${SSL_IP}
#echo SSL_SUBJECT=${SSL_SUBJECT}
#echo STARTING_IP=${STARTING_IP}
#echo REGISTRY_DOMAIN=${REGISTRY_DOMAIN}
#echo SWARM_NODE_PREFIX=${SWARM_NODE_PREFIX}
#echo SWARM_DOMAIN=${SWARM_DOMAIN}

function resourceExists {
	FILE=${ASW_RESOURCES}/$1
	if [ -e $FILE ]
	then
		return 0
	else
		return 1
	fi
}

function downloadExists {
	FILE=${ASW_DOWNLOADS}/$1
	if [ -e $FILE ]
	then
		return 0
	else
		return 1
	fi
}

function fileExists {
	FILE=$1
	if [ -e $FILE ]
	then
		return 0
	else
		return 1
	fi
}

#echo "common loaded"
