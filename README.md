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

osododo


## Section 3: **step-by-step guide** for setting up and optimizing an Amazon EKS Kubernetes cluster on **Windows**:

### **Task 1: Set up a Kubernetes Cluster using Amazon EKS on Windows**

#### **Prerequisites for Windows:**

Before starting, ensure you have the following tools installed:

1. **AWS CLI** – AWS Command Line Interface
2. **eksctl** – Command-line tool for creating EKS clusters
3. **kubectl** – Kubernetes CLI for interacting with the cluster
4. **Windows Subsystem for Linux (WSL)** (Optional) – If you'd like to use a Linux-like environment on Windows


### **Create an EKS Cluster**

1. **Create EKS Cluster Using eksctl**:

   Open **Command Prompt** or **PowerShell** and run the following command to create your EKS cluster:
   ```bash
   eksctl create cluster --name my-cluster --region us-west-2 --nodes 3 --node-type t3.medium
   ```

   This command will create a cluster named `my-cluster` in the `us-west-2` region with 3 worker nodes of type `t3.medium`.

### **Configure kubectl for EKS**

1. **Configure kubectl to use the new cluster**:
   After your cluster is created, configure kubectl to interact with your EKS cluster:
   ```bash
   aws eks --region us-west-2 update-kubeconfig --name my-cluster
   ```

2. **Verify Cluster Setup**:
   To confirm that your cluster is running correctly, check the status of your nodes:
   ```bash
   kubectl get nodes
   ```


   You should see the worker nodes listed as `Ready`.

---

### **Deploy a Sample Application**

1. **Create a Deployment YAML File**:
   Create a file called `nginx-deployment.yaml` and add the following content:
   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: nginx-deployment
   spec:
     replicas: 2
     selector:
       matchLabels:
         app: nginx
     template:
       metadata:
         labels:
           app: nginx
       spec:
         containers:
         - name: nginx
           image: nginx
           ports:
           - containerPort: 80
   ```

2. **Deploy the Application**:
   Apply the deployment to the cluster using `kubectl`:
   ```bash
   kubectl apply -f nginx-deployment.yaml
   ```

3. **Expose the Application**:
   Create a LoadBalancer service to expose the Nginx application:
   ```bash
   kubectl expose deployment nginx-deployment --type=LoadBalancer --port=80 --target-port=80
   ```

4. **Check the Service**:
   Verify the service and find the external IP address:
   ```bash
   kubectl get services
   ```

   After a few minutes, you should see an `EXTERNAL-IP` listed for the Nginx service.

5. **Access the Application**:
   Open the **EXTERNAL-IP** in a web browser. You should see the default Nginx landing page.

---

### **Task 2: Optimize the Kubernetes Cluster for High Availability and Scalability**

#### **Step 1: Enable Multi-AZ Support**

Amazon EKS automatically supports multi-AZ (Availability Zone) configurations. When creating the cluster using `eksctl`, it will place worker nodes across multiple availability zones for high availability.

You can also check the `availabilityZones` settings for your cluster by running:
```bash
eksctl get cluster --name my-cluster --region us-west-2
```

#### **Step 2: Horizontal Pod Autoscaler (HPA)**

To enable horizontal scaling based on resource usage (like CPU or memory), we can use the **Horizontal Pod Autoscaler (HPA)**.

1. **Install the Metrics Server**:
   The Metrics Server is needed to collect resource metrics (CPU, memory). Install it using the following command:
   ```bash
   kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.5.0/components.yaml
   ```

2. **Create Horizontal Pod Autoscaler**:
   You can create an autoscaler for your Nginx deployment like so:
   ```bash
   kubectl autoscale deployment nginx-deployment --cpu-percent=50 --min=1 --max=5
   ```

   This configuration will scale the number of pods between 1 and 5 based on the CPU usage (targeting 50%).

#### **Step 3: Enable Cluster Autoscaler**

The **Cluster Autoscaler** automatically adjusts the size of the cluster when the demand for resources increases or decreases.

1. **Install Cluster Autoscaler**:
   Use the following command to install the Cluster Autoscaler:
   ```bash
   kubectl apply -f https://github.com/kubernetes/autoscaler/releases/download/cluster-autoscaler-1.21.0/cluster-autoscaler-chart-1.21.0.yaml
   ```

   This will automatically scale your worker nodes up or down based on the demand.

#### **Configure StatefulSets for Stateful Applications**

For applications requiring persistent storage (like databases), use **StatefulSets** instead of Deployments to ensure pods retain their identity and storage.

1. **Create a MySQL StatefulSet**:
   Here is an example YAML for deploying MySQL using a StatefulSet:
   ```yaml
   apiVersion: apps/v1
   kind: StatefulSet
   metadata:
     name: mysql
   spec:
     serviceName: "mysql"
     replicas: 3
     selector:
       matchLabels:
         app: mysql
     template:
       metadata:
         labels:
           app: mysql
       spec:
         containers:
         - name: mysql
           image: mysql:5.7
           ports:
           - containerPort: 3306
           volumeMounts:
           - name: mysql-storage
             mountPath: /var/lib/mysql
     volumeClaimTemplates:
     - metadata:
         name: mysql-storage
       spec:
         accessModes: ["ReadWriteOnce"]
         resources:
           requests:
             storage: 1Gi
   ```

2. **Deploy the StatefulSet**:
   Apply the StatefulSet:
   ```bash
   kubectl apply -f mysql-statefulset.yaml
   ```

---

### **Conclusion**

Guide:

1. **Set up an Amazon EKS Kubernetes cluster on Windows**.
2. **Deployed a sample application (Nginx)** to verify the setup.
3. **Optimized the cluster for high availability** by ensuring multi-AZ deployment.
4. **Configured Horizontal Pod Autoscaling (HPA)** and **Cluster Autoscaler** for scalability.
5. **Deployed a StatefulSet** for stateful applications like MySQL.

