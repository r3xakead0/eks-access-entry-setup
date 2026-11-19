# EKS Access Entry Setup

A simple Bash script to configure Amazon EKS Access Entries and grant cluster administrator permissions to the currently authenticated AWS IAM Identity Center (SSO) role.

## Features

- Automatically detects the currently authenticated AWS SSO role.
- Retrieves the corresponding IAM Role ARN.
- Creates an EKS Access Entry.
- Associates the AmazonEKSClusterAdminPolicy.
- Verifies the associated access policy.
- Updates the local kubeconfig.

## Prerequisites

- AWS CLI v2
- kubectl
- Authenticated AWS credentials
- IAM permissions to manage EKS Access Entries and IAM roles
- An EKS cluster configured with `API` or `API_AND_CONFIG_MAP` authentication mode.

## Usage

Make the script executable:

```bash
chmod +x configure-eks-admin-access.sh
```

Configure your AWS profile and region:

```bash
export AWS_PROFILE=your-aws-profile
export AWS_REGION=us-west-2
```

Run the script:

```bash
./configure-eks-admin-access.sh your-eks-cluster
```

## Permissions

This script associates:

`arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy`

**Warning:** This grants full administrative access to the EKS cluster. Use only in environments where you are authorized to grant these permissions.

## License

MIT