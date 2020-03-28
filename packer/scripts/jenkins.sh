#!/bin/bash

hostnamectl set-hostname jenkins1

# Focus 
echo "nameserver 192.168.1.1" > /etc/resolv.conf

# Install Salt
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

yum install -y java jenkins
systemctl enable jenkins

firewall-cmd --add-port=8080/tcp --permanent
firewall-cmd --reload
