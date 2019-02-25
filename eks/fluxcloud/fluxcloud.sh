#!/bin/bash
if ! helm status fluxcloud; then
  helm install ../fluxcloud --wait --name fluxcloud \
    --namespace devops \
    -f ../fluxcloud/values.yaml
fi