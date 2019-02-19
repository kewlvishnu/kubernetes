#!/bin/bash
helm repo add weaveworks https://weaveworks.github.io/flux
if ! helm status flux; then
  helm install --wait --name flux \
    --namespace devops \
    -f ${fluxValuesFile} \
    weaveworks/flux
fi