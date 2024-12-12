#!/bin/bash
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo chkconfig httpd on
sudo mkdir /var/www/html/app1
sudo echo "this is the app1" > /var/www/html/app1/index.html