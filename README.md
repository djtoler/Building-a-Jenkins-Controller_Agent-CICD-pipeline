## Purpose
#### The prupose of this deployment was to evolve banking applications infrastructure system design. In Deployment 5, we decoupled our application and Jenkins server, partially solving the single point of failure problem. We also solved the problem of slow, error prone, manual infrastructre deployment by using Terraform (an Infrastructure As Code tool). 
#### While this increased the speed and consistency of our infrastructure deployment, our system design still needed improvements.

#### In the diagram below, in public subnet A, we have our Jenkins server for CICD and in public subnet B, we have our Banking application serever. 
#### This is a step in the right direction of building more resilliense into our system because if our application fails, we still have our Jenkins server available to quickly redeploy. Or if our application server fails, Terraform can quickly deploy new resources and infrastructre.




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
