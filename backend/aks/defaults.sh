#!/usr/bin/env bash

# AKS options
##################

KUBECTL_VERSION="${KUBECTL_VERSION:-v1.18.2}"

AZURE_CLUSTER_NAME="${AZURE_CLUSTER_NAME:-$(whoami)-cap}"
AZURE_NODE_COUNT="${AZURE_NODE_COUNT:-3}"
AZURE_LOCATION="${AZURE_LOCATION:-westus}"
AZURE_RESOURCE_GROUP="${AZURE_RESOURCE_GROUP:-}"

AZURE_APP_ID="${AZURE_APP_ID:-}"
AZURE_PASSWORD="${AZURE_PASSWORD:-}"
AZURE_TENANT_ID="${AZURE_TENANT_ID:-}"
AZURE_SUBSCRIPTION_ID="${AZURE_SUBSCRIPTION_ID:-}"

AZURE_DNS_JSON="${AZURE_DNS_JSON:-}"
AZURE_DNS_RESOURCE_GROUP="${AZURE_DNS_RESOURCE_GROUP:-susecap-domain}"
AZURE_DNS_DOMAIN="${AZURE_DNS_DOMAIN:-${AZURE_CLUSTER_NAME}.susecap.net}"

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
