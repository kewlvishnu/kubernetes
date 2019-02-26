#!/bin/bash
helm repo add weaveworks https://weaveworks.github.io/flux
export AWS_DEFAULT_REGION=us-east-1
if ! helm status flux; then
  export CHECKPOINT_DISABLE=true
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
# NOTE: https://github.com/weaveworks/flux/blob/master/site/faq.md#how-do-i-use-my-own-deploy-key
# NOTE2: https://github.com/stefanprodan/gitops-helm