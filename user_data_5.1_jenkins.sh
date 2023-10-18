#!/bin/bash

#Download the Jenkins, Python & AWS installation scripts
curl -O https://raw.githubusercontent.com/djtoler/automated_installation_scripts/main/auto-jenkins.sh
curl -O https://raw.githubusercontent.com/djtoler/automated_installation_scripts/main/auto-python.sh
curl -O https://raw.githubusercontent.com/djtoler/automated_installation_scripts/main/auto-aws_cli.sh

#Make the scripts executable
chmod +x auto-jenkins.sh
chmod +x auto-python.sh
chmod +x auto-aws_cli.sh

#Run the Jenkins, Python & AWS installation scripts
./auto-jenkins.sh
./auto-python.sh
./auto-aws_cli.sh