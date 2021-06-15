#!/bin/bash
apt update
apt install -y awscli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
apt install unzip 
unzip awscliv2.zip
sudo ./aws/install
apt install -y mysql-client
