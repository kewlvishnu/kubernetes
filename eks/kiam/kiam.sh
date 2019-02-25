#!/bin/bash
if ! helm status kiam; then
  helm install ../kiam --wait --name kiam \
    --namespace devops \
    -f ../kiam/values.yaml
fi