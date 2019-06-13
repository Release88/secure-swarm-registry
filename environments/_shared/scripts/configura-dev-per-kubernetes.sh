#!/bin/bash

echo "Nodo dev"
# apt-get install -y sshpass
# sshpass -p "vagrant" scp -o StrictHostKeyChecking=no vagrant@10.11.1.73:/home/vagrant/kubelet.conf .
# chown vagrant:vagrant /home/vagrant/kubelet.conf
mkdir -p /home/vagrant/.kube
mkdir -p /root/.kube
cp /home/asw/_shared/resources/config /home/vagrant/.kube/config
cp /home/asw/_shared/resources/config /root/.kube/config