#!/bin/bash

echo "Nodo master"
IP_ADDR=`ifconfig eth1 | grep inet | awk '{print $2}'| cut -f2 -d:`
HOST_NAME=$(hostname -s)
kubeadm init --apiserver-advertise-address=$IP_ADDR --apiserver-cert-extra-sans=$IP_ADDR  --node-name $HOST_NAME --pod-network-cidr=192.168.0.0/16
#copying credentials to regular user - vagrant
sudo --user=vagrant mkdir -p /home/vagrant/.kube
mkdir -p /root/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
cp -i /etc/kubernetes/admin.conf /root/.kube/config
chown $(id -u vagrant):$(id -g vagrant) /home/vagrant/.kube/config
export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml
kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml
kubeadm token create --print-join-command >> /etc/kubeadm_join_cmd.sh
cp /etc/kubeadm_join_cmd.sh /home/asw/_shared/resources/kubeadm_join_cmd.sh
chmod +x /home/asw/_shared/resources/kubeadm_join_cmd.sh
sudo sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
sudo service sshd restart
cp /home/vagrant/.kube/config /home/asw/_shared/resources/config