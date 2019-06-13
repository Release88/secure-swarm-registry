#!/bin/bash

docker login -u cabibbo -p prova my-registry:5000
cp /root/.docker/config.json /home/vagrant/.docker/config.json
chown -R vagrant:vagrant /home/vagrant/.docker