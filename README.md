## Purpose

#### The prupose of this deployment was to evolve banking applications infrastructure system design. In Deployment 5, we decoupled our application and Jenkins server, partially solving the single point of failure problem. We also solved the problem of slow, error prone, manual infrastructre deployment by using Terraform (an Infrastructure As Code tool). 
#### While this increased the speed and consistency of our infrastructure deployment, our system design still needed improvements.

#### In the diagram below, in public subnet A, we have our Jenkins server for CICD and in public subnet B, we have our Banking application serever. 

<p align="center">
<img src="https://github.com/djtoler/Deployment5_v1/blob/main/dp5Diagram2.png">
</p>

#### This is a step in the right direction of building more resilience into our system because if our application fails, we still have our Jenkins server available to quickly redeploy. Or if our application server fails, Terraform can quickly deploy new resources and infrastructre.

#### However, our system is still lacking reliability because even though it can quickly recover from a failure, it isn’t designed to avoid a failure. Each instance performs a different task that’s required for our system to function the way we intend for it to. But if one of those instances goes down, our customers may not be able to do any banking transactions. 

#### Deployment 5.1 helps to solve some of this problem by deploying 2 application instances, both with Jenkins agents. 

#### The 2 application instances makes our system more reliable by giving us an additional server that can be used as a backup to serve user requests of one fails. 

#### Utilizing Jenkins agents move us towards a more distributed system architecture, spreading our build/deploy jobs out to nodes that are controlled by our Jenkins server. This distributed approach makes our systems CICD pipeline faster (running builds at the same time) and more reliable because jobs can failover to other agents.

---

## Issues
### Issue 1: After trying to format the Jenkins file, we run into a error that I havent seen before and couldnt intuitivly get a idea of what the message meant.
##### `WorkflowScript: 7: expecting ''', found '\r' @ line 7, column 21. #!/bin/bash`
* ##### Solution: Reformatted Jenkins file back to its original state to speed up deploying the application
* ##### Takeaway: I later found that somehow a single quotes was deleted during the formatting

### Issue 2: There was an error when we initially tried to install our Jenkins agents on the application servers using [`sudo apt install default-jre`](https://ubuntu.com/tutorials/install-jre#2-installing-openjdk-jre) in our userdata script  
* ##### Solution: Manually install the Java Runtime Env because the installation failed when we tried to install it with our userdata script or use the Java installation script from Deployment 5
* ##### Takeaway: We found out later that running `sudo apt update` fixes our issue and allows us to successfully install out Jenkins agents


## Steps
#### Configure and deploy infastructure using Terraform
* ##### _1 VPC, 2 Availability Zones, 2 Public Subnets, 3 EC2s, 1 Route Table_
<p align="center">
<img src="https://github.com/djtoler/Deployment5_v1/blob/main/dp5Diagram2.png">
</p>

#### Configure Jenkins server
* ##### _The installations needed to run our Jenkins server & our application were installed in our userdata script during our infrastructure deployment_
  
#### Configure & run application server 1 & 2
* ##### _The installations needed to run our application were installed in our userdata script during our infrastructure deployment_
* ##### _Next, we install the Jenkins agent on our both application servers by following these steps._
```
    Select "Build Executor Status"
    Click "New Node"
    Choose a node name that will coorespond with the Jenkins agent defined in our Jenkins file
    Select permenant Agent
    Create the node
    Use the same name for the name field
    Enter "/home/ubuntu/agent1" as the "Remote root directory"
    Use the same name for the labels field
    Click dropdown menu and select "only build jobs with label expressions matrching this node"
    Click dropdown menu and select "launch agent via SSH"
    Enter the public IP address of the instance you want to install the agent on, in the "Host" field
    Click "Add" to add Jenkins credentials
    Click dropdown menu and select "select SSH username with private key"
    Use the same name for the ID field 
    Use "ubuntu" for the username
    Enter directly & add private key by pasting it into the box
    Click "Add" and select the ubuntu credentials
    Click dropdown menu and select "snon verifying verification strategy"
    Click save & check in Jenkins UI for a successful installation by clicking "Log"
```
* #### Now we create a MultiBranch pipeline by following these steps in the link below
```
https://github.com/djtoler/automated_installation_scripts/blob/main/manual_jenkins_multi_branch.txt
```

| Jenkins Server: Main Branch         | Application Server1: Dev1 Branch    | Application Server2: Dev2 Branch |
| ----------------------------------- | ----------------------------------- | --------------------------------- |
| ![aaaaaa.png](https://github.com/djtoler/Deployment5.1/blob/main/assets/mainsuc.PNG) | ![aaaaaa.png](https://github.com/djtoler/Deployment5.1/blob/main/assets/dev1suc.PNG) | ![aasaaaa](https://github.com/djtoler/Deployment5.1/blob/main/assets/dev2suc.PNG) |


---
| Application Server1: Banking App    | Application Server2: Banking App                      |
| ----------------------------------- | ----------------------------------- |
| ![aaafrrfaaa.png](https://github.com/djtoler/Deployment5.1/blob/main/assets/banksucdev1.PNG) | ![aaaaaa.png](https://github.com/djtoler/Deployment5.1/blob/main/assets/banksucdev2.PNG) | 




System Diagram

<p align="center">
<img src="https://github.com/djtoler/Deployment5.1/blob/main/assets/dp5.1Diagram.drawio%20(1).png">
</p>

---

Optimization

