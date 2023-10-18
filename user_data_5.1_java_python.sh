#!/bin/bash

#Download the Java, Python & AWS installation scripts
sudo apt install -y default-jre
curl -O https://raw.githubusercontent.com/djtoler/automated_installation_scripts/main/auto-python.sh
curl -O https://raw.githubusercontent.com/djtoler/automated_installation_scripts/main/auto-aws_cli.sh


#Make the scripts executable
chmod +x auto-python.sh
chmod +x auto-aws_cli.sh

#Run the Java, Python & AWS installation scripts
./auto-python.sh
./auto-aws_cli.sh