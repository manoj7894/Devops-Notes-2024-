#!/bin/bash
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo chkconfig docker on
sudo usermod -aG docker $USER
docker --version
sudo service docker start
sudo service docker status
