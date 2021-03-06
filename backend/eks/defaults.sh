#!/usr/bin/env bash

# EKS options
#############

EKS_CLUSTER_NAME="${EKS_CLUSTER_NAME:-$(whoami)-cap}"
EKS_LOCATION="${EKS_LOCATION:-us-west-2}"
EKS_KEYPAIR="${EKS_KEYPAIR:-$(whoami)-terraform}"
EKS_VERS="${EKS_VERS:-1.14}"
EKS_CLUSTER_LABEL=${EKS_CLUSTER_LABEL:-\{key = \"$(whoami)-eks-cluster\"\}}
HELM_VERSION="${HELM_VERSION:-v3.1.1}"

EKS_HOSTED_ZONE_NAME="${EKS_HOSTED_ZONE_NAME:-qa.aws.howdoi.website}"
EKS_DOMAIN="${EKS_DOMAIN:-${EKS_CLUSTER_NAME}.${EKS_HOSTED_ZONE_NAME}}"
EKS_DEPLOYER_ROLE_ARN="${EKS_DEPLOYER_ROLE_ARN:-}"
EKS_CLUSTER_ROLE_NAME="${EKS_CLUSTER_ROLE_NAME:-}"
EKS_CLUSTER_ROLE_ARN="${EKS_CLUSTER_ROLE_ARN:-}"
EKS_WORKER_NODE_ROLE_NAME="${EKS_WORKER_NODE_ROLE_NAME:-}"
EKS_WORKER_NODE_ROLE_ARN="${EKS_WORKER_NODE_ROLE_ARN:-}"

KUBE_AUTHORIZED_ROLE_ARN="${KUBE_AUTHORIZED_ROLE_ARN:-}"

# Settings for terraform state save/restore
#
# Set to a non-empty key to trigger state save in deploy.sh.
TF_KEY="${TF_KEY:-}"

# zip for terraform folder which includes tf state file.
# set this to use clean.sh, if there is no cap-terraform folder
TFSTATE="${TFSTATE:-}"
#
# s3 bucket and bucket region to save state to. Ignored when
# TF_KEY is empty (default, see above).
TF_BUCKET="${TF_BUCKET:-cap-ci-tf}"
TF_REGION="${TF_REGION:-us-west-2}"
