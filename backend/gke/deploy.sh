#!/usr/bin/env bash

# Requires:
# - gcloud credentials present

. ./defaults.sh
. ../../include/common.sh
. .envrc

# check gcloud credentials:
info "Using creds from GKE_CRED_JSON…"
gcloud auth revoke 2>/dev/null || true
gcloud auth activate-service-account --project "$GKE_PROJECT" --key-file "$GKE_CRED_JSON"
if [[ $(gcloud auth list  --format="value(account)" | wc -l ) -le 0 ]]; then
    err "GKE_CRED_JSON creds don't authenticate, aborting" && exit 1
fi
# one needs the following roles. We cannot check programmatically as
# you normally don't have permission to list roles:
# gcloud projects add-iam-policy-binding <project> \
#        --member=user:<user> \
#        --role=roles/container.admin

git clone https://github.com/SUSE/cap-terraform.git -b cap-ci
pushd cap-terraform/gke || exit

cat <<HEREDOC > terraform.tfvars
project        = "$GKE_PROJECT"
location       = "$GKE_LOCATION"
node_pool_name = "$GKE_CLUSTER_NAME"
node_count     = "$GKE_NODE_COUNT"
vm_type        = "UBUNTU"
gke_sa_key     = "$GKE_CRED_JSON"
gcp_dns_sa_key = "$GKE_DNSCRED_JSON"
cluster_labels = {
    catapult-clustername = "$GKE_CLUSTER_NAME",
    owner = "$(whoami)"
}
cluster_name   = "$GKE_CLUSTER_NAME"
k8s_version    = "latest"
HEREDOC

if [ -n "${TF_KEY}" ] ; then
    cat > backend.tf <<EOF
terraform {
  backend "s3" {
      bucket = "${TF_BUCKET}"
      region = "${TF_REGION}"
      key    = "${TF_KEY}"
  }
}
EOF
fi

# terraform needs helm client installed and configured:
helm_init_client

info "Deploying GKE cluster with terraform…"

terraform init

terraform plan -out=my-plan

if [ -n "${TF_KEY}" ] ; then
    # zip the terraform folder to use in concourse pool
    zip -r9  "${BUILD_DIR}/tf-setup.zip" .
fi

terraform apply -auto-approve my-plan

popd || exit

# Create kubeclusterreference file for kubeconfig generation
cat << EOF > kubeclusterreference
---
kind: ClusterReference
platform: gke
cluster-name: ${GKE_CLUSTER_NAME}
cluster-zone: ${GKE_LOCATION}
project: ${GKE_PROJECT}
EOF

# wait for cluster ready:
wait_ns kube-system

info "Configuring deployed GKE cluster…"

ROOTFS=overlay-xfs
# take first worker node as public ip:
PUBLIC_IP="$(kubectl get nodes -o json | jq -r '.items[].status.addresses[] | select(.type == "InternalIP").address' | head -n 1)"
if ! kubectl get configmap -n kube-system 2>/dev/null | grep -qi cap-values; then
    kubectl create configmap -n kube-system cap-values \
            --from-literal=garden-rootfs-driver="${ROOTFS}" \
            --from-literal=public-ip="${PUBLIC_IP}" \
            --from-literal=domain="${GKE_DNSDOMAIN}" \
            --from-literal=platform=gke
fi

create_rolebinding() {

    kubectl create clusterrolebinding admin --clusterrole=cluster-admin --user=system:serviceaccount:kube-system:default
    kubectl create clusterrolebinding uaaadmin --clusterrole=cluster-admin --user=system:serviceaccount:uaa:default
    kubectl create clusterrolebinding scfadmin --clusterrole=cluster-admin --user=system:serviceaccount:scf:default

    kubectl apply -f - <<HEREDOC
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  annotations:
    rbac.authorization.kubernetes.io/autoupdate: "true"
  labels:
    kubernetes.io/bootstrapping: rbac-defaults
  name: cluster-admin
rules:
- apiGroups:
  - '*'
  resources:
  - '*'
  verbs:
  - '*'
- nonResourceURLs:
  - '*'
  verbs:
  - '*'
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: kube-system:default
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: default
  namespace: kube-system
HEREDOC
}
create_rolebinding

ok "GKE cluster deployed"
