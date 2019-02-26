#!/bin/bash
helm repo add weaveworks https://weaveworks.github.io/flux
export AWS_DEFAULT_REGION=us-east-1
if ! helm status flux; then
  helm install --wait --name flux \
    --namespace devops \
    -f ../flux/values-preprod.yaml \
    --kubeconfig ../terraform/kubeconfig \
    weaveworks/flux
fi
# kubectl get customresourcedefinition
# kubectl delete customresourcedefinition XXXXXXXXXXXXXX
# helm delete --purge flux
# this is to be done when the helmchart has been deleted, but still the CRD remains