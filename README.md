# DevOps Interview Assessment

This repository contains answers and implementation scripts for a DevOps interview task. It covers the following key areas:

- DevOps principles and practices
- Infrastructure provisioning with Terraform
- Kubernetes cluster setup and optimization
- CI/CD pipeline creation and Docker image deployment
- Monitoring, logging, and configuration management tools

Each section includes relevant code, configuration files, and documentation.
---

## Section 1: DevOps Principles

### **Question 1:**
**Explain the key principles of DevOps and how they contribute to the overall success of a software development lifecycle.**

### **Answer:**
-DevOps is built on a few core principles that aim to improve collaboration, automation, and continuous delivery in the software development lifecycle. The key principles include Collaboration & communication, automated testing deployment and infrastructure provisioning, continuous integration and deployment (CI/CD), monitoring and feedback, infrastructure as Code(IaC)

## Section 2: Real-world DevOps Scenario

### Question 2:  
Describe a scenario where you implemented DevOps practices to solve a specific problem. What was the outcome?

### Answer:

In my previous role, our team faced challenges with code testing and automated deployments, which slowed down the development cycle and introduced inconsistencies in production.  
We had to set up a CI pipeline using GitHub Actions to automate unit and integration tests for every pushed or a pull request was created. This improved code quality and helped us catch bugs early.

Also during peak usage hours, we experienced performance bottlenecks. We solved this by implementing AWS Load Balancers to distribute traffic across multiple instances. Additionally, we configured auto-scaling to resize infrastructure based on usage.
