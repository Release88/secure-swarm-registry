#!/bin/bash

apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
# kubelet requires swap off
swapoff -a
# keep swap off after reboot
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
# ip of this box
IP_ADDR=`ifconfig eth1 | grep inet | awk '{print $2}'| cut -f2 -d:`
if [[ ! -e /etc/default/kubelet ]]; then
    touch /etc/default/kubelet
fi
echo -e "KUBELET_EXTRA_ARGS=--node-ip=$IP_ADDR --cgroup-driver=cgroupfs" >> /etc/default/kubelet
sudo systemctl restart kubelet
cp -r /etc/docker/certs.d/my-registry\:5000 /etc/docker/certs.d/my-registry\:30500