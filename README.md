# 🚀 Terragrunt DevOps Project

Version: 1.0

## 📖 Overview

This project demonstrates a complete GitOps-based DevOps platform on AWS using Terraform, Terragrunt, Helm, Amazon EKS, Amazon ECR, GitHub Actions, Docker, Kubernetes, and ArgoCD.

The infrastructure is provisioned using reusable Terraform modules managed through Terragrunt. Application deployments are automated using GitHub Actions, while ArgoCD continuously synchronizes Kubernetes manifests stored in GitHub to the Amazon EKS cluster.

This project follows GitOps principles where Git acts as the single source of truth for Kubernetes deployments.

---

# 🏗️ Architecture

GitHub → GitHub Actions → Amazon ECR → ArgoCD → Amazon EKS

### Deployment Workflow

* Developer pushes application code changes to GitHub.
* GitHub Actions automatically triggers the CI pipeline.
* Docker image is built from the application source code.
* Image is pushed to Amazon ECR.
* GitHub Actions updates the image tag in Kubernetes deployment manifests.
* Updated manifests are committed back to GitHub.
* ArgoCD detects the manifest changes.
* ArgoCD synchronizes the EKS cluster.
* Kubernetes performs a rolling deployment of the new version.

---

# ⚙️ Technologies Used

## Infrastructure as Code

* Terraform
* Terragrunt

## Cloud Services

* AWS VPC
* AWS EKS
* AWS ECR
* AWS S3 (Remote Backend)

## Containerization

* Docker
* Nginx

## CI/CD

* GitHub Actions

## GitOps

* ArgoCD

## Package Management

* Helm

## Container Orchestration

* Kubernetes

---

# 📂 Project Structure

```
terragrunt-devops-project/
│
├── app/
│   ├── Dockerfile
│   └── index.html
│
├── k8s/
│   ├── deployment.yaml
│   └── service.yaml
│
├── .github/
│   └── workflows/
│       └── main.yml
│
├── modules/
│   ├── vpc/
│   ├── eks/
│   └── ecr/
│
├── live/
│   ├── dev/
│   │   ├── vpc/
│   │   ├── eks/
│   │   └── ecr/
│   │
│   ├── stg/
│   └── prod/
│
├── .gitignore
└── README.md
```

---

# Multi-Environment Design

The project structure is designed to support multiple environments using Terragrunt.

## Environment Status

- dev ✅ Implemented
- stg ⏳ Planned
- prod ⏳ Planned

Environment-specific configurations are organized under the `live/` directory.

Future enhancements will include:

- Staging environment deployment
- Production environment deployment
- Environment promotion workflows
- Approval gates between environments
- Environment-specific variables and configurations

---

# ☁️ Infrastructure Components

## VPC

* Custom VPC
* Public Subnets
* Private Subnets
* Internet Gateway
* Route Tables

## Amazon EKS

* Managed Kubernetes Cluster
* Managed Node Group
* IAM Roles and Policies
* Auto Scaling Configuration

## Amazon ECR

* Private Container Registry
* Image Scanning Enabled
* Secure Image Storage

---

# 🔄 CI/CD Pipeline

GitHub Actions automates the following tasks:

* Checkout application source code
* Build Docker image
* Authenticate with Amazon ECR
* Push image to ECR
* Update Kubernetes deployment manifest
* Commit updated manifest back to GitHub

## Image Versioning

Docker images are versioned automatically using GitHub Actions run numbers.

Examples:

* v1
* v2
* v3
* v4

Example:

```
395516497310.dkr.ecr.ap-south-1.amazonaws.com/terragrunt-devops-project-app:v3
```

---

# 🚢 GitOps with ArgoCD

ArgoCD continuously monitors the Kubernetes manifests stored in GitHub.

Enabled Features:

* Automatic Sync
* Self Heal
* Prune Resources

Any change made inside the `k8s` directory is automatically synchronized to the EKS cluster.

Examples:

* Updating image tags
* Scaling replicas
* Modifying services
* Creating ConfigMaps
* Creating Secrets
* Adding Ingress resources

---

# 📦 Helm Integration

Helm is used to install and manage ArgoCD on the Kubernetes cluster.

Benefits:

* Simplified installation
* Easy upgrades
* Easy rollbacks
* Standard Kubernetes package management

Installation Commands:

```
helm repo add argo https://argoproj.github.io/argo-helm

helm repo update

kubectl create namespace argocd

helm install argocd argo/argo-cd \
  --namespace argocd \
  --set server.service.type=LoadBalancer
```

---

# 🚀 Deployment Process

## Step 1: Provision Infrastructure

Deploy VPC:

```
cd live/dev/vpc

terragrunt apply
```

Deploy ECR:

```
cd ../ecr

terragrunt apply
```

Deploy EKS:

```
cd ../eks

terragrunt apply
```

---

## Step 2: Configure kubectl

```
aws eks update-kubeconfig \
  --region ap-south-1 \
  --name dev-eks-cluster
```

Verify Cluster:

```
kubectl get nodes
```

---

## Step 3: Install ArgoCD

Install ArgoCD using Helm.

Verify Pods:

```
kubectl get pods -n argocd
```

---

## Step 4: Create ArgoCD Application

Configure:

* Repository URL
* Revision (HEAD)
* Path (k8s)
* Automatic Sync
* Self Heal
* Prune Resources

---

## Step 5: Deploy Application

Push application changes:

```
git add .

git commit -m "Application update"

git push
```

GitHub Actions automatically:

* Builds Docker image
* Pushes image to ECR
* Updates deployment manifest
* Pushes updated manifest to GitHub

ArgoCD automatically:

* Detects Git change
* Synchronizes cluster
* Deploys latest application version

---

# 🔍 Challenges and Troubleshooting

## Kubernetes Pod Scheduling Issue

### Issue

```
0/1 nodes are available: 1 Too many pods
```

### Root Cause

The EKS worker node reached the maximum pod limit supported by the AWS VPC CNI plugin.

### Resolution

Scaled node group configuration from:

```
desired_size = 1
```

To:

```
desired_size = 2
min_size     = 2
max_size     = 3
```

### Result

* Application pod successfully scheduled
* ArgoCD status changed to Healthy
* Deployment completed successfully

---

# 🎯 Key Learnings

* Built reusable Terraform modules
* Managed infrastructure using Terragrunt
* Configured remote Terraform state using Amazon S3
* Implemented GitOps using ArgoCD
* Installed and managed ArgoCD using Helm
* Automated deployments using GitHub Actions
* Integrated Amazon ECR with Kubernetes deployments
* Managed workloads on Amazon EKS
* Troubleshot Kubernetes pod density limitations
* Implemented end-to-end CI/CD and GitOps workflows

---

# 🔮 Future Enhancements

* AWS Load Balancer Controller
* Kubernetes Ingress Controller
* Route53 Integration
* HTTPS using AWS ACM
* Prometheus Monitoring
* Grafana Dashboards
* Cluster Autoscaler
* Multi-Environment Deployments (Dev, Staging, Production)
* ArgoCD Installation using Terraform Helm Provider
* Blue/Green Deployments
* Canary Deployments

---

# 👨‍💻 Author

**Sushil**

DevOps Engineer | Cloud Engineer | Site Reliability Engineering Enthusiast

### Skills Demonstrated

* AWS
* Terraform
* Terragrunt
* Helm
* Docker
* Kubernetes
* Amazon EKS
* Amazon ECR
* GitHub Actions
* ArgoCD
* GitOps
* CI/CD

🚀 Building scalable cloud-native platforms through automation and GitOps.
