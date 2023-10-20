## Purpose
#### The prupose of this deployment was to evolve banking applications infrastructure system design. In Deployment 5, we decoupled our application and Jenkins server, partially solving the single point of failure problem. We also solved the problem of slow, error prone, manual infrastructre deployment by using Terraform (an Infrastructure As Code tool). 
#### While this increased the speed and consistency of our infrastructure deployment, our system design still needed improvements.

#### In the diagram below, in public subnet A, we have our Jenkins server for CICD and in public subnet B, we have our Banking application serever. 
#### This is a step in the right direction of building more resilliense into our system because if our application fails, we still have our Jenkins server available to quickly redeploy. Or if our application server fails, Terraform can quickly deploy new resources and infrastructre.

However, our system is still lacking reliability because even though it can quickly recover from a failure, it isn’t designed to avoid a failure. Each instance performs a different task that’s required for our system to function the way we intend for it to. But if one of those instances goes down, our customers may not be able to do any banking transactions. 

Deployment 5.1 helps to solve some of this problem by deploying 2 application instances, both with Jenkins agents. 

The 2 application instances makes our system more reliable by giving us an additional server that can be used as a backup to serve user requests of one fails. 

Utilizing Jenkins agents move us towards a more distributed system architecture, spreading our build/deploy jobs out to nodes that are controlled by our Jenkins server. This distributed approach makes our systems CICD pipeline faster (running builds at the same time )and more reliable because jobs can failover to other agents


Issues
Steps
System Diagram
Optimization


<p align="center">
<img src="https://github.com/djtoler/Deployment5.1/blob/main/dp5.1Diagram.drawio.png">
</p>

<p align="center">
<img src="https://github.com/djtoler/Deployment5.1/blob/main/dp5.1_jenkins_success.PNG">
</p>

<p align="center">
<img src="https://github.com/djtoler/Deployment5.1/blob/main/app_success.PNG">
</p>

<p align="center">
<img src="https://github.com/djtoler/Deployment5.1/blob/main/app_success2.PNG">
</p>
