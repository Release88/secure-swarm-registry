#!/bin/bash

source "/home/asw/_shared/scripts/common.sh"

#
# copia il file OVERRIDE.CONF per sovrascrivere la configurazione di docker 
# - abilita la comunicazione remota del nodo 
# - abilita my-registry:5000 come registry insicuro 
# - abilita la protezione tramite crittografia
# - pensato per il nodo swarm manager

mkdir -p /etc/systemd/system/docker.service.d
cp ${ASW_RESOURCES}/docker.service.d/override-dev.conf /etc/systemd/system/docker.service.d/override.conf
chmod a-x /etc/systemd/system/docker.service.d/override.conf