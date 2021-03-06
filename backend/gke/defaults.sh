#!/usr/bin/env bash

# GKE options
#############

GKE_PROJECT="${GKE_PROJECT:-suse-css-platform}"
GKE_LOCATION="${GKE_LOCATION:-europe-west4-a}"
GKE_CLUSTER_NAME="${GKE_CLUSTER_NAME:-$(whoami)-cap}"
GKE_CRED_JSON="${GKE_CRED_JSON:-}"
GKE_DNSCRED_JSON="${GKE_DNSCRED_JSON:-${GKE_CRED_JSON}}"
GKE_NODE_COUNT="${GKE_NODE_COUNT:-3}"
GKE_DNSDOMAIN="${GKE_DNSDOMAIN:-${GKE_CLUSTER_NAME}.ci.kubecf.charmedquarks.me}"

HELM_VERSION="${HELM_VERSION:-v3.1.1}"

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
