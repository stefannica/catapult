#!/bin/bash
set -x

pushd build
    helm del --purge susecf-uaa
    helm del --purge susecf-scf
    kubectl delete secret --all
    kubectl delete pod --all -n eirini
    kubectl delete pvc --all -n eirini
    kubectl delete pod --all -n cf
    kubectl delete secret --all -n eirini
    ./kind delete cluster
popd 

rm -rf build