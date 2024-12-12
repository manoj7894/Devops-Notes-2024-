#!/bin/bash
# To install AWS CLI
sudo yum update -y
sudo yum install python3-pip -y
sudo pip3 install awscli
aws --version

# To install Kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client