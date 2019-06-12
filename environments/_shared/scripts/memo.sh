#!/bin/bash

###
# per tutti
###
IP_ADDR=10.11.1.72
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
if [[ ! -e /etc/default/kubelet ]]; then
    touch /etc/default/kubelet
fi
sudo sed -i "/^[^#]*KUBELET_EXTRA_ARGS=/c\KUBELET_EXTRA_ARGS=--node-ip=$IP_ADDR" /etc/default/kubelet


###
# per master node
###
IP_ADDR = 10.11.1.71
HOST_NAME=$(hostname -s)
kubeadm init --apiserver-advertise-address=$IP_ADDR --apiserver-cert-extra-sans=$IP_ADDR  --node-name $HOST_NAME --pod-network-cidr=10.11.1.0/24
sudo --user=vagrant mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown $(id -u vagrant):$(id -g vagrant) /home/vagrant/.kube/config
export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml
kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml
kubeadm token create --print-join-command >> /etc/kubeadm_join_cmd.sh
chmod +x /etc/kubeadm_join_cmd.sh
sudo sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config

###
# per altri nodi
###
apt-get install -y sshpass
sshpass -p "vagrant" scp -o StrictHostKeyChecking=no vagrant@10.11.1.71:/etc/kubeadm_join_cmd.sh .
sh ./kubeadm_join_cmd.sh





swarm-3: master
swarm-2, swarm-1: nodi
dev: dev

si costruisce swarm-3:
- si creano i certificati da tenere in comune
- si creano i certificati del registry da salvare ed impostare
- si avvia kubernetes come nodo master
- si crea il file per il join da salvare
- si crea il file per il controllo del cluster da salvare

si costruiscono swarm-2 e swarm-1:
- si prendono i certificati del registry e si salvano
- si prendono i file per controllo del cluster e per il join
- si fa il join nel cluster tramite file salvato

su swarm-1:
- si avvia il registry

su dev: 
- si installa tutto (java e gradle compresi)
- si settano i file di accesso al registro


installazione my-registry:
kubectl apply -f registry-pod.yaml
kubectl create -f registry-port.yaml




// installazione con load balancer
kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.7.3/manifests/metallb.yaml
kubectl apply -f /home/asw/_shared/resources/load-balancer-configuration.yaml
kubectl apply -f /home/asw/_shared/resources/registry-deployment.yaml



da dev:

fare login al registry privato
docker login -u cabibbo -p prova my-registry:5000
kubectl create secret generic regcred --from-file=.dockerconfigjson=/home/vagrant/.docker/config.json --type=kubernetes.io/dockerconfigjson
./start-sentence-deployment.sh