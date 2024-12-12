#!/bin/bash
sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo chkconfig httpd on
sudo mkdir /var/www/html/app1
sudo echo "this is the app1" > /var/www/html/app1/index.html

sudo yum install docker -y
sudo service docker start
sudo chkconfig docker on
sudo usermod -aG docker $USER
docker --version
sudo service docker start
sudo service docker status

sudo yum update -y
sudo yum install python3-pip -y
sudo pip3 install awscli
aws --version