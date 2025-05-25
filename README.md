# Three-Tier Web Application Deployment on AWS EKS using AWS EKS, ArgoCD, Prometheus, Grafana, and Jenkins
[![LinkedIn](https://img.shields.io/badge/Connect%20with%20me%20on-LinkedIn-blue.svg)](https://www.linkedin.com/in/mahmoud-soliman427/)
[![GitHub](https://img.shields.io/github/stars/AmanPathak-DevOps.svg?style=social)](https://github.com/mahmoudsoli)


Welcome to the Three-Tier Web Application Deployment project! 🚀

This repository hosts the implementation of a Three-Tier Web App using ReactJS, NodeJS, and MongoDB, deployed on AWS EKS. The project covers a wide range of tools and practices for a robust and scalable DevOps setup.

## Table of Contents
- [Application Code](#application-code)
- [Github CI Pipeline Code](#Github-CI-Pipeline-Code)
- [Terraform-Code](#Terraform-Code)
- [Kubernetes Manifests Files](#kubernetes-manifests-files)
- [Project Details](#project-details)

## Application Code
The `src` directory contains the source code for the Three-Tier Web Application. Dive into this directory to explore the frontend and backend implementations.

## Github CI Pipeline Code
In the `.github` directory, you'll find CI pipeline scripts. These scripts automate the CI process, ensuring smooth integration and deployment of your application.

## Terraform-Code
Explore the `Terraform-Code` directory to find Terraform scripts for setting up the EKS Cluster and the Infrastructure [VPC, Subnets, SG, IGW, Route Tables] on AWS. These scripts simplify the infrastructure provisioning process.

## Kubernetes Manifests Files
The `K8S` directory holds Kubernetes manifests for deploying your application on AWS EKS. Understand and customize these files to suit your project needs.

## Project Details
🛠️ **Tools Explored:**
- Terraform & AWS CLI for AWS infrastructure
- Github-Actions, trivy, gitleaks, Terraform, Kubectl and Helm for CI setup
- ArgoCD for GitOps practices
- OpenLens, Prometheus, and Grafana for Monitoring

🚢 **High-Level Overview:**
- IAM User setup & Terraform magic on AWS
- EKS Cluster creation & Load Balancer configuration
- Helm charts for efficient monitoring setup
- GitOps with ArgoCD - the cherry on top!

📈 **The journey covered everything from setting up tools to deploying a Three-Tier app, ensuring data persistence, and implementing CI/CD pipelines.**

## Getting Started
## Infrastructure Setup with Terraform
The infrastructure was provisioned using Terraform with the modules approach, which provides better reusability and modularization.

Created Components: VPC (with public/private subnets, route tables, IGW, etc.) and EKS Cluster with worker nodes

Terraform Command Sequence:
```sh
terraform init
terraform plan
terraform apply
```
Each major component like vpc, eks, and node_groups was defined in separate modules and then invoked in the root main.tf.

## Continuous Integration (CI) Pipeline
A Git-based CI pipeline was implemented to ensure code security and quality before deployment.

# Tools Used:
# ✅ GitLeaks
Purpose: Detect secrets and sensitive data committed in code (e.g., API keys, tokens).
Integration: It runs during the CI stage to prevent any hardcoded secrets from being pushed to the repo.

# ✅ Trivy
Purpose: Scan Docker images for known vulnerabilities (CVEs), misconfigurations, and exposed secrets.
Integration: It scans the built container image before pushing it to the registry.


## Set Up the AWS Load Balancer Controller on an Amazon EKS cluster
First you need to update the kubeconfig
```sh
aws eks update-kubeconfig --region us-east-1 --name otel-cluster
```

1. To allow the cluster to use AWS Identity and Access Management (IAM) for service accounts, run the following command:
```sh
eksctl utils associate-iam-oidc-provider \
  --cluster YOUR_CLUSTER_NAME \
  --approve
```

2. To download an IAM policy that allows the AWS Load Balancer Controller to make calls to AWS APIs on your behalf, run the following command:
```sh
 curl -o iam_policy.json https://raw.githubusercontent.com/kubernete
 ```

3. To create an IAM policy with the downloaded policy, run the following create-policy AWS CLI command:
```sh
aws iam create-policy \
  --policy-name AWSLoadBalancerControllerIAMPolicy \
  --policy-document file://iam_policy.json
```

4. To create a service account for the AWS Load Balancer Controller, run the following command:
```sh
eksctl create iamserviceaccount \
  --cluster=YOUR_CLUSTER_NAME \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn=arn:aws:iam::AWS_ACCOUNT_ID:policy/AWSLoadBalancerControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --approve
```

5. To verify that the new service role is created, run one of the following commands:
```sh
eksctl get iamserviceaccount \
  --cluster=YOUR_CLUSTER_NAME \
  --name=aws-load-balancer-controller \
  --namespace=kube-system
```

# Install the AWS Load Balancer Controller with Helm
Complete the following steps:

1. To add the Amazon EKS chart to Helm, run the following command:
```sh
helm repo add eks https://aws.github.io/eks-charts
```

2. To update the repository and pull the latest chart, run the following command:
```sh
helm repo update eks 
```

3. To install the Helm chart, run the following command:
```sh
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  --set clusterName=YOUR_CLUSTER_NAME \
  --set serviceAccount.create=false \
  --set region=YOUR_REGION_CODE \
  --set vpcId=EKS_CLUSTER_VPC_ID \
  --set serviceAccount.name=aws-load-balancer-controller \
  --version 1.11.0 \
  -n kube-system
```

4. To verify that the controller installed correctly, run the following command:
```sh
kubectl get deployment -n kube-system aws-load-balancer-controller
```

# Argo CD Installation with Helm
Argo CD was installed via Helm for GitOps-based continuous delivery.

Helm Installation Commands:
```sh
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
```
Then install Argo CD in the argocd namespace:

```sh
helm install argocd argo/argo-cd --namespace argocd --create-namespace --set server.service.type=LoadBalancer
```

Get Argo-CD UI URL:
```sh
kubectl get svc argocd-server -n argocd
```
or you can access it using Port-Forward
```sh
kubectl port-forward svc/argocd-server -n argocd 8080:443
```
and from the browser
```sh
https://localhost:8080
```

Get Argo CD Admin Password:
To retrieve the initial admin password for the Argo CD UI:
```sh
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode
```


## Install Prmethues and Grafana
Adding helm repo
```sh
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts 
```

Updating the repo
```sh
helm repo update
```

Creating namespace for monitoring
```sh
kubectl create namespace monitoring 
```

Installing:
```sh
helm install monitoring prometheus-community/kube-prometheus-stack --namespace monitoring 
```

then you can use portforwarding to access prometheus
```sh
kubectl port-forward -n monitoring pod/monitoring-kube-prometheus-prometheus-0 9090
http://localhost:9090
```

for grafana
```sh
kubectl port-forward -n monitoring pod/monitoring-grafana-5c548d845b-5p77w 3000:3000
http://localhost:3000
```


We welcome contributions! If you have ideas for enhancements or find any issues, please open a pull request or file an issue.

## License
This project is licensed under the [MIT License](LICENSE).

Happy Coding! 🚀
