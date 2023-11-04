# Deployment 5.1

<p align="center">
<img src="https://github.com/djtoler/Deployment5.1/blob/main/assets/5.1cover.png">
</p>

## Purpose

#### The prupose of this deployment was to evolve our banking applications infrastructure system design. In Deployment 5, we decoupled our application and Jenkins server, partially solving the single point of failure problem. We also solved the problem of slow, error prone, manual infrastructre deployment by using Terraform (an Infrastructure As Code tool). 
#### While this increased the speed and consistency of our infrastructure deployment, our system design still needed improvements.

#### In the diagram below, public subnet A has have our Jenkins server for CICD and in public subnet B, we have our Banking application server. 

<p align="center"><img src="https://github.com/djtoler/Deployment5.1/blob/main/assets/dp5.1-5purposediagram.png" height="75%"></p>

#### This is a step in the right direction of building more resilience into our system because if our application fails, we still have our Jenkins server & Terraform available to quickly redeploy. Or if our application server fails, Terraform can quickly deploy new resources and infrastructre.

#### However, our system is still lacking reliability because even though it can quickly recover from a failure, it isn’t designed to avoid a failure. Each instance performs a different task that’s required for our system to function the way we intend for it to. But if one of those instances goes down, our customers may not be able to do any banking transactions. 

### Deployment 5.1 helps to solve some of this problem by deploying 2 application instances, both with Jenkins agents. 

#### The 2 application instances makes our system more reliable by giving us an additional server that can be used as a backup to serve user requests of one fails. 
#### Utilizing Jenkins agents moves us towards a more distributed system architecture, spreading our build/deploy jobs out to nodes that are controlled by our Jenkins server. This distributed approach makes our systems CICD pipeline... 
* ##### <u>Faster</u> (running builds at the same time)
* ##### <u>More Reliable</u> (jobs can easily failover to other agents if configured and [labeled to do so](https://github.com/djtoler/Deployment5.1/blob/main/assets/jenkinslabels.PNG))
* ##### <u>More Flexible</u> (agents can be assigned to instances based on type of workload.  _exp: if our Banking application used analytics & our pipeline had a test stage that ran computationally intensive verification scripts, we can install that agent on a [CPU optimized EC2 instance](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/compute-optimized-instances.html) to control our job durations_)

| Deployment 5 Infrastructure (_Single Points of Failure_)         | Deployment 5.1 Infrastructure (_Fault Tolerance_)    |
| ----------------------------------- | ----------------------------------- |
| ![aaafrrfaaa.png](https://github.com/djtoler/Deployment5.1/blob/main/assets/dp5.1-5purposediagram.png) | ![aaaaaa.png](https://github.com/djtoler/Deployment5.1/blob/main/assets/dp5.1purposediagram.png) | 

### We also get a security benifit from using our Jenkins agents to SSH into our server as opposed to using our Jenkinsfile to SSH into our server like we did for Deployment 5.
#### Since our SSH task was in the Clean, Build and Deploy stages of our Jenkinsfile in our last deployment, we need that key everytime we redeploy our application.
#### Using Jenkins agents, we wont need to utilize the key for every redeployment because the agent will have the key stored with it while its on our instance. Reducing the use of the key reduces the possibility of it being compromised.

| Deployment 5 SSH Key Access         | Deployment 5.1 SSH Key Access    |
| ----------------------------------- | ----------------------------------- |
| ![aaafrrfaaa.png](https://github.com/djtoler/Deployment5.1/blob/main/assets/dp5sshk2.drawio.png) | ![aaaaaa.png](https://github.com/djtoler/Deployment5.1/blob/main/assets/dp5.1ssh2.png) | 

---

## Issues
### Issue 1: After trying to format the Jenkins file, we run into a error that I havent seen before and couldnt intuitivly get a idea of what the message meant.
##### `WorkflowScript: 7: expecting ''', found '\r' @ line 7, column 21. #!/bin/bash`
* ##### Solution: Reformatted Jenkins file back to its original state to speed up deploying the application
* ##### Takeaway: I later found that somehow a single quotes was deleted during the formatting

### Issue 2: There was an error when we initially tried to install our Jenkins agents on the application servers using [`sudo apt install default-jre`](https://ubuntu.com/tutorials/install-jre#2-installing-openjdk-jre) in our userdata script
<p align="left">
<img src="https://github.com/djtoler/Deployment5.1/blob/main/assets/dp5.1agenterror.PNG">
</p>

* ##### Solution: Manually install the Java Runtime Env because the installation failed when we tried to install it with our userdata script or use the Java installation script from Deployment 5
* ##### Takeaway: We found out later that running `sudo apt update` fixes our issue and allows us to successfully install out Jenkins agents


## Steps
#### 1) Configure and deploy infastructure using Terraform
* ##### _1 VPC, 2 Availability Zones, 2 Public Subnets, 3 EC2s, 1 Route Table_

| 1) variables.tf                     | 2) terraform.tfvars                 | 3) main.tf                        |
| ----------------------------------- | ----------------------------------- | --------------------------------- |
| ![aaaaaa.png](https://github.com/djtoler/Deployment5_v1/blob/main/Screenshot%202023-10-15%20at%201.04.23%20PM.png) | ![aaaaaa.png](https://github.com/djtoler/Deployment5_v1/blob/main/image6-3.png) | ![aasaaaa](https://github.com/djtoler/Deployment5_v1/blob/main/Screenshot%202023-10-15%20at%201.59.34%20PM.png) |

| 4) tf_deploy.sh                     | 5) Deployment 5.1 Infrastructure    |
| ----------------------------------- | ----------------------------------- |
| ![aaafrrfaaa.png](https://github.com/djtoler/Deployment5_v1/blob/main/dp5_tf_auto.png) | ![aaaaaa.png](https://github.com/djtoler/Deployment5.1/blob/main/assets/dp5.1Infrastructurerequirements.png) | 

#### 2) Configure Jenkins server
* ##### _The installations needed to run our Jenkins server & our application were installed in our userdata script during our infrastructure deployment_

```
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
```
  
#### 3) Configure & run application server 1 & 2
* ##### _The installations needed to run our application were installed in our userdata script during our infrastructure deployment_
```
#!/bin/bash

#Update apt
sudo apt update


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
```
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

| Main Branch                         | Application Server1: Dev1 Branch    | Application Server2: Dev2 Branch |
| ----------------------------------- | ----------------------------------- | --------------------------------- |
| ![aaaaaa.png](https://github.com/djtoler/Deployment5.1/blob/main/assets/mainsuc.PNG) | ![aaaaaa.png](https://github.com/djtoler/Deployment5.1/blob/main/assets/dev1suc.PNG) | ![aasaaaa](https://github.com/djtoler/Deployment5.1/blob/main/assets/dev2suc.PNG) |

* #### After successfully running our MultiBranch pipeline, we can visit our Banking applications from both IP addresses 

| Application Server1: Banking App    | Application Server2: Banking App    |
| ----------------------------------- | ----------------------------------- |
| ![aaafrrfaaa.png](https://github.com/djtoler/Deployment5.1/blob/main/assets/banksucdev1.PNG) | ![aaaaaa.png](https://github.com/djtoler/Deployment5.1/blob/main/assets/banksucdev2.PNG) | 

---

## System Diagram

<p align="center">
<img src="https://github.com/djtoler/Deployment5.1/blob/main/assets/dp5.1Diagram.drawio%20(1).png">
</p>

---

## Optimization
* #### Move the all of our instances into private subnets(security)
    * ##### _With the data sensitivity of a Banking application, anything that isnt a html/css/javascript/image file should be on a instance in a private subnet_ 
* #### Use a different relational database & seperate it from the application(security)
    * ##### _SQLite has limited features and operates within our application, making our users data too vulnerable_  
* #### Seperate the application logic, business logic & database logic and pass data between modules & servers(scalability, optimization)
    * ##### _Example: Our code routes users requests(application logic), runs calculations to deposit/withdraw funds(business logic) & executes database transations(database logic) all in our app.py file. During the upcoming holiday season our number of transactions will multiply. Our application server may be able to handle a 100k GET requests per minute to pass data but our business logic server wont be able to process 100K calculations as easily. If our code was logically isolated on different servers, we could just horizontally auto-scale our business logic instance to support CPU intensive days._  
* #### Load balance between Application server 1 and Application server 2 (performance, reliability)
    * ##### _This would distribute the load our application would recieve...._  
* #### Seperate Application server 1 and Application server 2 into different Availability Zones (availability)
* #### Implement a CDN for the CSS/HTML/JavaScript files that are in the static & templates directories (performance)
* #### Cache our users profile data
    * ##### _To retieve users data like names, email addresses, account balances faster and lighten the read load on our database_
    * 


|#| Step   | Jenkinsfile  | Terraform  |
|---|---|---|---|
|1. | Jenkins agent on Docker instance starts working pipeline  | ![a.png](https://github.com/djtoler/Deployment5.1/blob/main/assets/dp5.1agenterror.PNG)  | |
|2. | DockerHub credentials set in Jenkins enviornment  | ![a.png](https://github.com/djtoler/Deployment5.1/blob/main/assets/dp5ssh.PNG)  | ![a.png](https://github.com/djtoler/Deployment5.1/blob/main/assets/jenkinslabels.PNG)   |
|3. | Test stage ran on Docker instance  |   |   |
|4. |   |   |   |
||   |   |   |
||   |   |   |
||   |   |   |

