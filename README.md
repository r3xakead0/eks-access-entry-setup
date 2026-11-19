# EKS Access Entry Setup

Bash scripts to configure Amazon EKS Access Entries for the currently authenticated AWS IAM Identity Center (SSO) role. Use the view script for read-only access, the admin script for namespace-scoped administration, or the cluster-admin script for full cluster administration.

## Features

- Automatically detects the currently authenticated AWS SSO role.
- Retrieves the corresponding IAM Role ARN.
- Creates an EKS Access Entry.
- Associates `AmazonEKSViewPolicy`, `AmazonEKSAdminPolicy`, or `AmazonEKSClusterAdminPolicy`.
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

Make the scripts executable:

```bash
chmod +x configure-eks-view-access.sh \
  configure-eks-admin-access.sh \
  configure-eks-cluster-admin-access.sh
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

Grant administrative access to one or more namespaces:

```bash
./configure-eks-admin-access.sh your-eks-cluster namespace-a namespace-b
```

Grant full cluster administrator access:

```bash
./configure-eks-cluster-admin-access.sh your-eks-cluster
```

## Permissions

The view script associates:

`arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy`

The admin script associates the following policy with only the namespaces passed as arguments:

`arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy`

The cluster-admin script associates the following policy with the entire cluster:

`arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy`

**Warning:** `AmazonEKSClusterAdminPolicy` grants full administrative access to the EKS cluster. Use it only where you are authorized to grant these permissions.

## License

MIT
