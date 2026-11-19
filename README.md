# EKS Access Entry Setup

Bash scripts to configure Amazon EKS Access Entries for the currently authenticated AWS IAM Identity Center (SSO) role. Use the view script for read-only access or the admin script for administrative access.

## Features

- Automatically detects the currently authenticated AWS SSO role.
- Retrieves the corresponding IAM Role ARN.
- Creates an EKS Access Entry.
- Associates either `AmazonEKSViewPolicy` or `AmazonEKSAdminPolicy`.
- Verifies the associated access policy.
- Updates the local kubeconfig.
- Reuses an existing access entry when one is already configured.

## Prerequisites

- AWS CLI v2
- kubectl
- Authenticated AWS credentials
- IAM permissions to manage EKS Access Entries and IAM roles
- An EKS cluster configured with `API` or `API_AND_CONFIG_MAP` authentication mode.

## Usage

Make both scripts executable:

```bash
chmod +x configure-eks-view-access.sh configure-eks-admin-access.sh
```

Configure your AWS profile and region:

```bash
export AWS_PROFILE=your-aws-profile
export AWS_REGION=us-west-2
```

Grant read-only access:

```bash
./configure-eks-view-access.sh your-eks-cluster
```

Grant administrative access:

```bash
./configure-eks-admin-access.sh your-eks-cluster
```

## Permissions

The view script associates:

`arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy`

The admin script associates:

`arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy`

**Warning:** The admin policy grants broad administrative access to Kubernetes resources. Unlike `AmazonEKSClusterAdminPolicy`, it does not grant every permission in the cluster. Use it only where you are authorized to grant these permissions.

## License

MIT
