# Finure Terraform Apps repo

## Overview
The main objective of this repository is to demonstrate the working a IaC model with parallel, centralized, PR-based, machine oriented automated Terraform workflows with reduced deployment conflicts and state errors, enhanced reliability & governance along with YAML abstraction layer for simplified user configurations of cloud resources. This repository contains the Terraform configuration files to set up the cloud infrastructure for Finure microservices. The infrastructure includes modules for creating GitHub repositories, GCS buckets and IAM related resources for various Finure microservices.

## Prerequisites

Before getting started, ensure you have the following:
- Kubernetes cluster bootstrapped ([Finure Terraform](https://github.com/finure/terraform))
- Infrastructure setup via Flux ([Finure Kubernetes](https://github.com/finure/kubernetes))

## Repository Structure

The repository has the following structure:
```
terraform-apps/
├── .github/                     # Contains GitHub Actions workflows
├── applications/                # Contains YAML files for GCP resources to be created for each application
├── github-repos/                # Contains YAML files for GitHub repositories to be created
├── modules/
│   ├── gcs/                     # Module for creating GCS buckets
│   │   ├── locals.tf
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── github/                  # Module for creating GitHub repositories
│   │   ├── locals.tf
│   │   ├── main.tf
│   │   └── provider.tf
│   └── iam/                     # Module for creating IAM roles and bindings
│       ├── locals.tf
│       ├── main.tf
│       └── variables.tf
└── README.md                   # Project documentation
```

## Infrastructure Components

The Terraform code in this repository sets up the following infrastructure components:
- **GitHub Repositories:** Creates and manages GitHub repositories for various Finure microservices
- **GCS Buckets:** Provisions Google Cloud Storage buckets for storing application data and artifacts
- **IAM Roles and Bindings:** Configures IAM roles and bindings to manage access control for Finure microservices

## Usage

This repository is intended to be used by Atlantis to create and manage the infrastructure for Finure microservices. To make changes to the infrastructure, create a pull request with the desired modifications. Atlantis will automatically validate and apply the changes upon approval.

## Github Actions
The repository includes GitHub Actions workflows to automate the following tasks:
- **Terraform Format:** Ensures that the Terraform code is properly formatted
- **Cost Check:** Validates the cost estimation for the proposed infrastructure changes and posts the result as a comment on the PR
- **Checkov:** Validates the Terraform code using Checkov for security and best practices
- **Label PRs:** Automatically labels pull requests based on the changes made

## Additional Information

This repo is primarily designed to be used in the Finure project only