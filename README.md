# GitOps Terraform for Amazon EKS Cluster (IaC PART OF THE PROJECT)

![image alt](https://github.com/Ashsatsan/gitops-terra/blob/main/images/PHASE1.png?raw=true)


This repository contains Terraform configurations to deploy an Amazon Elastic Kubernetes Service (EKS) cluster using Infrastructure as Code (IaC). The deployment process is triggered via GitHub Actions, with two branches configured:

- **`stage`**: Performs a dry run (`terraform plan`) to validate changes.
- **`main`**: Applies the Terraform configuration (`terraform apply`) to create or update resources.

## IMPORTANT NOTE:
This project is just the Iac part of the project to properly execute the whole part of the project, after performing this follow the reference repository:
[gitops-argocd](https://github.com/Ashsatsan/gitops-argocd)

## Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [GitHub Actions Workflow](#github-actions-workflow)
4. [Branching Strategy](#branching-strategy)
5. [Deployment Instructions](#deployment-instructions)
6. [Security Considerations](#security-considerations)
7. [Contributing](#contributing)
8. [Aws Resources](#Aws-Resources)

---

## Overview

This project automates the creation of an Amazon EKS cluster using Terraform. It includes:

- **EKS Cluster**: Configured with two managed node groups.
- **VPC and Networking**: A Virtual Private Cloud (VPC) with private subnets for the EKS cluster.
- **IAM Roles and Policies**: IAM roles and policies for GitHub Actions to interact with AWS services like ECR, EKS, and ArgoCD.
- **OpenID Connect (OIDC)**: OIDC provider for secure GitHub Actions integration.
- **CI/CD Workflow**: GitHub Actions workflow to trigger Terraform commands based on branch (`stage` for dry runs, `main` for applying changes).

---

## Prerequisites

Before deploying the infrastructure, ensure the following prerequisites are met(if applying locally):
(Although this project does not require any installation if its done via github directly because even a slighest change into the repository will trigger the workflow and github actions will perform the mentioned task
which already has the terraform inbuilt in it)

1. **AWS Account**: An active AWS account with sufficient permissions to create EKS clusters, VPCs, IAM roles, and other resources.
2. **Terraform Installed**: Install Terraform locally or use a CI/CD pipeline to run Terraform commands.
   - Download Terraform: [https://www.terraform.io/downloads.html](https://www.terraform.io/downloads.html)
3. **AWS CLI**: Install and configure the AWS CLI with appropriate credentials.
   - Installation Guide: [https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
4. **GitHub Repository**: Fork this repository and configure GitHub Actions secrets for AWS credentials.
5. **S3 Bucket**: An S3 bucket named `gitiopsbob` in the `us-east-2` region to store Terraform state files.

---

## GitHub Actions Workflow

The GitHub Actions workflow is defined in `.github/workflows/gitops-terraform.yml`. It supports two branches:

### 1. `stage` Branch
- **Purpose**: Validates changes without applying them.
- **Steps**:
  - Runs `terraform init`, `terraform fmt`, `terraform validate`, and `terraform plan`.
  - Outputs the Terraform plan for review.
  - Does not apply changes to AWS resources.

### 2. `main` Branch
- **Purpose**: Applies changes to AWS resources.
- **Steps**:
  - Runs all steps from the `stage` branch.
  - Executes `terraform apply` to create or update resources.
  - Configures AWS CLI for `kubectl` interaction with the EKS cluster.
  - Optionally installs an ingress controller.

---

## Branching Strategy

- **`stage` Branch**:
  - Used for testing and validation.
  - Changes are pushed to this branch to perform a dry run (`terraform plan`).
  - No resources are created or modified in AWS.

- **`main` Branch**:
  - Used for production deployments.
  - After validating changes in the `stage` branch, merge them into `main`.
  - Resources are created or updated in AWS when changes are pushed to this branch.
    
---

## Deployment Instructions

### 1. Push to `stage` Branch
1. Make changes to your Terraform configuration.
2. Push the changes to the `stage` branch:
   ```bash
   git checkout stage
   git add .
   git commit -m "Add/update Terraform configuration"
   git push origin stage
   ```
3. Monitor the GitHub Actions workflow for the `stage` branch to ensure the plan succeeds.

### 2. Merge to `main` Branch
1. Once the `stage` branch plan succeeds, merge the changes into `main`:
   ```bash
   git checkout main
   git merge stage
   git push origin main
   ```
2. Monitor the GitHub Actions workflow for the `main` branch to ensure the apply succeeds.

---

## Security Considerations

1. **Least Privilege**: IAM roles and policies are scoped to the minimum required permissions.
2. **Secrets Management**: Use GitHub Actions secrets to securely store AWS credentials.
3. **State File Encryption**: Enable server-side encryption for the S3 bucket storing Terraform state files.
   ![image alt](https://github.com/Ashsatsan/gitops-terra/blob/main/images/terra7.png?raw=true)
   
---

## Contributing

Contributions are welcome! To contribute:

1. Fork the repository.
2. Create a new branch for your changes.
3. Submit a pull request with a detailed description of your changes.

---

## Aws Resources

1.Here, Terraform created a secured vpc with private network connection(using NAT GATEWAY)

![image alt](https://github.com/Ashsatsan/gitops-terra/blob/main/images/terra2.png?raw=true)

2.Then EKS cluster is created with the compute of 2 nodes within the vpc

![image alt](https://github.com/Ashsatsan/gitops-terra/blob/main/images/terra1.png?raw=true)

3.Instead of giving full permission minimum priviledge is given wih the help of oicd via terraform for the aws console to the gitops-build repository which will eventually perform cicd

![image alt](https://github.com/Ashsatsan/gitops-terra/blob/main/images/terra3.png?raw=true)

4.AWS Security Token Service (STS), which is a web service that enables you to request temporary, limited-privilege credentials for AWS resources

![image alt](https://github.com/Ashsatsan/gitops-terra/blob/main/images/terra4.png?raw=true)

5.For assurance that role consider the policy we created from the terraform IaC 

![image alt](https://github.com/Ashsatsan/gitops-terra/blob/main/images/terra5.png?raw=true)

6.Inside the trust relationship of the given role check if the AWS security token is adhered

![image alt](https://github.com/Ashsatsan/gitops-terra/blob/main/images/terra6.png?raw=true)









---


