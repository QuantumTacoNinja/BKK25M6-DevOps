#!/bin/bash

HOST_IP="ec2-13-236-146-184.ap-southeast-2.compute.amazonaws.com"

ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@${HOST_IP} "sudo systemctl stop myapp || true"
        
scp -o StrictHostKeyChecking=no -i ${FILENAME} myapp.service ${USERNAME}@${HOST_IP}:/tmp/myapp.service
scp -o StrictHostKeyChecking=no -i ${FILENAME} main ${USERNAME}@${HOST_IP}:/tmp/main

ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@${HOST_IP} "
# Create system user if it doesn't exist
sudo id -u myapp &>/dev/null || sudo useradd -r -s /bin/false myapp

# Prepare app directory
sudo mkdir -p /opt/myapp
sudo mv /tmp/main /opt/myapp/main
sudo chown myapp:myapp /opt/myapp/main
sudo chmod 755 /opt/myapp/main

# Install systemd service
sudo mv /tmp/myapp.service /etc/systemd/system/myapp.service
sudo chmod 644 /etc/systemd/system/myapp.service

# Reload and start service
sudo systemctl daemon-reload
sudo systemctl enable myapp
sudo systemctl restart myapp
"
