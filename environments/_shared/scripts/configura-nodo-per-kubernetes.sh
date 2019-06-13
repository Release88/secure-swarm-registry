#!/bin/bash

echo "Nodo kubernetes"
# apt-get install -y sshpass
# sshpass -p "vagrant" scp -o StrictHostKeyChecking=no vagrant@10.11.1.73:/etc/kubeadm_join_cmd.sh .
# sh ./kubeadm_join_cmd.sh
# sshpass -p "vagrant" scp -o StrictHostKeyChecking=no vagrant@10.11.1.73:/home/vagrant/kubelet.conf .
# chown vagrant:vagrant /home/vagrant/kubelet.conf
cp /home/asw/_shared/resources/kubeadm_join_cmd.sh .
chmod +x kubeadm_join_cmd.sh
sh ./kubeadm_join_cmd.sh
mkdir -p /home/vagrant/.kube
mkdir -p /root/.kube
cp /home/asw/_shared/resources/config /home/vagrant/.kube/config
cp /home/asw/_shared/resources/config /root/.kube/config