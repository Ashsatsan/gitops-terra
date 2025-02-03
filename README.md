# GitOps Infrastructure & CI/CD Automation

This repository demonstrates an end-to-end GitOps pipeline that automates the deployment of applications on AWS using Terraform to provision infrastructure (VPC, EKS, IAM, and OIDC) and GitHub Actions (integrated with ArgoCD and other tools) for CI/CD. This project is designed for interview demonstrations and real-world implementations, showcasing best practices in infrastructure as code and continuous deployment.

---

## Table of Contents

- [Overview](#overview)
- [Repository Structure](#repository-structure)
- [Infrastructure Components](#infrastructure-components)
  - [EKS Cluster](#eks-cluster)
  - [VPC Setup](#vpc-setup)
  - [IAM and OIDC Configuration](#iam-and-oidc-configuration)
- [Terraform Files Explanation](#terraform-files-explanation)
- [Setup & Deployment Steps](#setup--deployment-steps)
- [Expected AWS Console Outputs](#expected-aws-console-outputs)
- [Troubleshooting](#troubleshooting)
- [Conclusion](#conclusion)

---

## Overview

This project uses Terraform to build an AWS EKS cluster with supporting infrastructure including a VPC, subnets, and networking components. In addition, the project configures an OIDC provider with GitHub Actions, sets up an IAM policy and role for secure interaction with AWS services (ECR, EKS, EC2, etc.), and attaches the necessary policies. The repository is split into modules that handle distinct aspects of the infrastructure:

- **Infrastructure Provisioning (`gitops-terra`)**: Contains Terraform code to set up AWS resources.
- **Application Build & Deployment (`gitops-build`)**: Contains CI/CD workflows (integrated with GitHub Actions, Maven, Docker, ArgoCD, etc.) to build, test, and deploy applications.

---

## Repository Structure

. ├── eks-cluster.tf # Defines the EKS cluster using terraform-aws-modules/eks/aws ├── main.tf # Contains AWS and Kubernetes provider configurations ├── output.tf # Outputs key variables such as the cluster name, endpoint, region, and security group ID ├── terraform.tf # Configures required Terraform providers and the S3 backend for state management ├── variables.tf # Declares variables for AWS region, cluster name, GitHub organization, and repository ├── vpc.tf # Sets up a VPC with public and private subnets using terraform-aws-modules/vpc/aws └── oidc.tf # Configures OIDC provider and IAM policies/roles for GitHub Actions to interact with AWS resources

markdown
Copy
Edit

---

## Infrastructure Components

### EKS Cluster

- **eks-cluster.tf**: Uses the official Terraform AWS EKS module to create an EKS cluster with the following specifications:
  - **Cluster Version:** 1.27
  - **Managed Node Groups:** Two managed node groups are configured:
    - **node-group-1:** Uses `t3.small` instances (desired capacity: 2, with scaling between 1 and 3).
    - **node-group-2:** Uses `t3.small` instances (desired capacity: 1, with scaling between 1 and 2).
  - **Networking:** The cluster is deployed in private subnets (sourced from the VPC module).

### VPC Setup

- **vpc.tf**: Utilizes the `terraform-aws-modules/vpc/aws` module to create a dedicated VPC:
  - **CIDR Block:** 172.20.0.0/16
  - **Subnets:** 3 private and 3 public subnets are defined.
  - **NAT Gateway:** Configured with a single NAT Gateway for cost efficiency.
  - **Tags:** Kubernetes-specific tags are added to both public and private subnets for proper resource association with the EKS cluster.

### IAM and OIDC Configuration

- **oidc.tf**:
  - **OIDC Provider:** Creates an IAM OIDC provider for GitHub Actions (`https://token.actions.githubusercontent.com`) allowing secure, federated access.
  - **IAM Policy:** Defines a custom policy (`ECREKSArgoCDAccessPolicy`) granting permissions to interact with ECR, EKS, IAM, EC2, and S3.
  - **IAM Role:** Creates an IAM role (`github-actions-eks-role`) that GitHub Actions can assume using web identity federation. The role’s assume policy is configured with conditions to restrict access to the specified GitHub organization and repository.
  - **Policy Attachment:** Attaches the IAM policy to the GitHub Actions role.

---

## Terraform Files Explanation

- **main.tf**
  - Configures the AWS provider (region defined in `variables.tf`).
  - Sets up the Kubernetes provider using the EKS cluster endpoint and certificate authority data.
  
- **terraform.tf**
  - Specifies required Terraform providers (aws, random, tls, cloudinit, kubernetes).
  - Configures the S3 backend for storing Terraform state (bucket: `gitiopsbob`, key: `terraform.tfstate`).

- **variables.tf**
  - Declares variables such as `region`, `clusterName`, `github_org`, and `github_repo`. Validation rules ensure that the GitHub organization and repository values match the expected names.

- **output.tf**
  - Exposes key outputs (cluster name, endpoint, region, and cluster security group ID) that can be referenced by other applications or modules.

- **eks-cluster.tf**
  - Uses the Terraform AWS EKS module to define the cluster, node groups, and related configurations.
  - References the VPC module to integrate networking components.

- **vpc.tf**
  - Defines the VPC, subnets, NAT gateway, and associated tags that help with resource discovery in the AWS console.
  
- **oidc.tf**
  - Creates the IAM OIDC provider for GitHub Actions.
  - Creates and attaches the necessary IAM policies and roles for allowing GitHub Actions secure access to AWS resources.

---

## Setup & Deployment Steps

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/your-username/gitops-terra.git
   cd gitops-terra
Configure AWS Credentials:

Ensure that your AWS CLI is configured with the appropriate credentials and permissions:

bash
Copy
Edit
aws configure
Terraform Initialization:

Initialize the Terraform working directory to download required modules and providers:

bash
Copy
Edit
terraform init
Plan the Deployment:

Generate an execution plan to preview the changes:

bash
Copy
Edit
terraform plan -out=tfplan
Apply the Configuration:

Apply the changes to your AWS environment:

bash
Copy
Edit
terraform apply tfplan
Verify AWS Resources:

After a successful apply, verify the following in the AWS console:

VPC and Subnets: Confirm that the VPC, public, and private subnets are created with the correct CIDR ranges and tags.
EKS Cluster: Check the EKS dashboard for your cluster (vprofile1-eks) along with the node groups.
OIDC Provider & IAM Role: Under IAM, review the OIDC provider (token.actions.githubusercontent.com) and the GitHub Actions role (github-actions-eks-role) with attached policies.
Expected AWS Console Outputs
Below are example screenshots from the AWS console after deployment:

VPC Console:


EKS Cluster:


OIDC Provider:


IAM Role:


Note: Replace the image paths with your actual image filenames as they appear in your project.

Troubleshooting
Terraform Execution Issues
AWS Credentials:

Problem: Terraform cannot authenticate with AWS.
Solution: Verify your AWS credentials (aws configure) and ensure that the credentials have the necessary permissions for VPC, EKS, IAM, and related resources.
Module Version Conflicts:

Problem: Module versions might conflict or be unavailable.
Solution: Double-check the versions specified in your Terraform files. Run terraform init -upgrade to update modules and providers.
S3 Backend Errors:

Problem: Issues with remote state (e.g., permission denied or missing bucket).
Solution: Ensure the S3 bucket (gitiopsbob) exists and that your IAM user has permissions to access the bucket. Confirm the bucket region and key are correctly specified.
GitHub Actions and CI/CD Pipeline
OIDC Role Assumption:

Problem: GitHub Actions workflows fail to assume the IAM role.
Solution: Ensure the OIDC provider is correctly configured, and the trust relationship in the IAM role restricts access only to the specified repository (gitops-argocd) and organization (Ashsatsan).
CI/CD Deployment Failures:

Problem: Application deployment fails during build or sync.
Solution: Check logs from Maven, Docker build, and ArgoCD sync. Validate that Docker images are successfully pushed to ECR and that ArgoCD is configured to track the correct repository and branch.
Conclusion
This GitOps project demonstrates the automation of AWS infrastructure and CI/CD pipelines using Terraform, GitHub Actions, and associated cloud-native tools. The code is modular and organized to promote reusability and scalability. By following the provided steps, you can deploy a secure, production-ready environment that integrates AWS EKS with GitHub Actions for continuous delivery.

Feel free to reach out for further details or clarifications. Best of luck with your interview demonstration!
