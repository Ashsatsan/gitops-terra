variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "clusterName" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "vprofile1-eks"
}

variable "github_org" {
  description = "GitHub organization name"
  type        = string
  default     = "Ashsatsan"

  validation {
    condition     = var.github_org == "Ashsatsan"
    error_message = "The github_org must be 'Ashsatsan'."
  }
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "gitops-argocd"

  validation {
    condition     = var.github_repo == "gitops-argocd"
    error_message = "The github_repo must be 'gitops-argocd'."
  }
}

