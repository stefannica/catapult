#!/usr/bin/env bash

. ./defaults.sh
. ../../include/common.sh

if [ ! -f "$KUBECFG" ]; then
    err "No KUBECFG given - you need to pass one!"
    exit 1
fi

cp "$KUBECFG" kubeconfig

# kubeconfig gets hardcoded paths for gcloud bin, reevaluate them:
gcloud_path="$(which gcloud)"
gcloud_path_esc=$(echo "$gcloud_path" | sed 's_/_\\/_g')
sed -e "s/\(cmd-path\: \).*/\1$gcloud_path_esc/" kubeconfig > kubeconfig.bkp
mv kubeconfig.bkp kubeconfig

kubectl get nodes 1> /dev/null || exit

ok "Kubeconfig for $BACKEND correctly imported"
