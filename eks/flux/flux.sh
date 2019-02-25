#!/bin/bash
helm repo add weaveworks https://weaveworks.github.io/flux
if ! helm status flux; then
  helm install --wait --name flux \
    --namespace devops \
    -f ../flux/values-preprod.yaml \
    weaveworks/flux
fi
# kubectl get customresourcedefinition
# kubectl delete customresourcedefinition XXXXXXXXXXXXXX
# helm delete --purge flux
# this is to be done when the helmchart has been deleted, but still the CRD remains