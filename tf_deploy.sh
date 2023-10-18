#!/bin/bash

#Initialize Terraform files
terraform init 

#Validate Terraform configurations
terraform validate

#See what Terraform plans to deploy based on configurations
terraform plan 

#Apply the changes to state file and deploy infrastructure
terraform apply -auto-approve

