#!/bin/bash

set -ex

. ../../include/common.sh
. .envrc
kubectl apply -f "$ROOT_DIR"/kube/socks.yaml

sleep 5

bash "$ROOT_DIR"/include/wait_ns.sh default

echo "Now you can run: make ingress-forward &"
echo "Afterwards you can access your cluster network by setting socks5://127.0.0.1:$KUBEPROXY_PORT as your proxy. e.g. https_proxy=socks5://127.0.0.1:$KUBEPROXY_PORT"