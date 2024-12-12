#!/bin/bash
sudo yum update -y
sudo dnf update
sudo dnf install mariadb105-server -y
sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo systemctl status mariadb

sudo yum install python3-pip -y
sudo pip3 install awscli
aws --version