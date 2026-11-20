#!/usr/bin/env bash

set -euo pipefail

# Usage: ./configure-eks-edit-access.sh <cluster-name> <namespace> [namespace...]

if (( $# < 2 )); then
  echo "Usage: $0 <cluster-name> <namespace> [namespace...]"
  exit 2
fi

CLUSTER_NAME="$1"
shift
NAMESPACES=("$@")
printf -v NAMESPACE_LIST '%s,' "${NAMESPACES[@]}"
NAMESPACE_LIST="${NAMESPACE_LIST%,}"
REGION="${AWS_REGION:-${AWS_DEFAULT_REGION:-us-west-2}}"

echo "Cluster: $CLUSTER_NAME"
echo "Region: $REGION"
echo "Namespaces: $NAMESPACE_LIST"

# Get current SSO role name
PRINCIPAL_NAME=$(aws sts get-caller-identity \
  --query 'Arn' \
  --output text | cut -d'/' -f2)

echo "SSO Role: $PRINCIPAL_NAME"

# Get IAM Role ARN
ROLE_ARN=$(aws iam list-roles \
  --query "Roles[?RoleName=='${PRINCIPAL_NAME}'].Arn | [0]" \
  --output text)

if [[ -z "$ROLE_ARN" || "$ROLE_ARN" == "None" ]]; then
  echo "ERROR: IAM role not found."
  exit 1
fi

echo "Principal ARN: $ROLE_ARN"

# Step 1: Create EKS Access Entry when it does not already exist
if aws eks describe-access-entry \
  --cluster-name "$CLUSTER_NAME" \
  --principal-arn "$ROLE_ARN" \
  --region "$REGION" \
  >/dev/null 2>&1; then
  echo "Access entry already exists."
else
  aws eks create-access-entry \
    --cluster-name "$CLUSTER_NAME" \
    --principal-arn "$ROLE_ARN" \
    --type STANDARD \
    --region "$REGION"
fi

# Step 2: Associate edit policy only with the requested namespaces
aws eks associate-access-policy \
  --cluster-name "$CLUSTER_NAME" \
  --principal-arn "$ROLE_ARN" \
  --policy-arn arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy \
  --access-scope "type=namespace,namespaces=${NAMESPACE_LIST}" \
  --region "$REGION"

# Step 3: Verify access policy
aws eks list-associated-access-policies \
  --cluster-name "$CLUSTER_NAME" \
  --principal-arn "$ROLE_ARN" \
  --region "$REGION"

# Step 4: Update kubeconfig
aws eks update-kubeconfig \
  --name "$CLUSTER_NAME" \
  --region "$REGION"

echo "EKS namespace edit access configured successfully!"
