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


Here's a step-by-step guide you can include in your README.md file for executing Task 1:

# Terraform AWS Infrastructure Provisioning Guide

## Task 1: Infrastructure Provisioning

### Prerequisites
- AWS account with programmatic access
- AWS CLI configured with credentials
- Terraform installed (v1.0+ recommended)
- Git installed

### Step-by-Step Execution

1. **Clone the Repository**
   ```bash
   git clone this repo
   cd terraform-aws-infra
   ```

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Review the Configuration**
   The infrastructure consists of:
   - 1 VPC
   - 1 public subnet (for EC2)
   - 1 private subnet (for RDS)
   - 1 EC2 instance in public subnet
   - 1 MySQL RDS instance in private subnet

4. **Create terraform.tfvars file**
   ```bash
   cat > terraform.tfvars <<EOF
   db_password = "YourSecurePassword123!"
   EOF
   ```

5. **Plan the Infrastructure**
   ```bash
   terraform plan
   ```

6. **Apply the Configuration**
   ```bash
   terraform apply
   ```
   Type "yes" when prompted to confirm

7. **Verify Resources**
   - EC2 Public IP will be shown in outputs
   - RDS endpoint will be shown in outputs (marked sensitive)

8. **Access the EC2 Instance**
   ```bash
   ssh ec2-user@$(terraform output -raw ec2_public_ip)
   ```

9. **Connect to RDS from EC2**
   ```bash
   mysql -h $(terraform output -raw rds_endpoint) -u admin -p
   ```

## Task 2: State Management & Reproducibility

### State Management
1. **Remote State**
   ```terraform
   terraform {
     backend "s3" {
       bucket         = "your-unique-state-bucket"
       key            = "terraform.tfstate"
       region         = "us-east-1"
       dynamodb_table = "terraform-lock"
       encrypt        = true
     }
   }
   ```

2. **State Locking**
   - Uses DynamoDB to prevent concurrent operations
   - Automatically managed by Terraform

### Reproducibility
1. **Version Control**
   - All Terraform files committed to Git
   - .gitignore excludes:
     ```gitignore
     *.tfstate
     *.tfstate.*
     .terraform/
     *.tfvars
     ```

2. **Version Pinning**
   ```terraform
   terraform {
     required_version = ">= 1.0.0"
     
     required_providers {
       aws = {
         source  = "hashicorp/aws"
         version = "~> 4.0"
       }
     }
   }
   ```

3. **CI/CD Integration**
   - Use Terraform Cloud or GitHub Actions
   - Plan runs on PRs, Apply on merge to main

### Cleanup
```bash
terraform destroy
```
