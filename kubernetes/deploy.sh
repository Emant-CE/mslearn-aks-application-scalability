#!/bin/bash

export RESOURCE_NAME=learn-aks-scalability

echo "Creating cluster..."

az group create -n $RESOURCE_NAME -l eastus

az aks create -g $RESOURCE_NAME -n $RESOURCE_NAME --node-count=1 --generate-ssh-keys --enable-addons http_application_rounting --vm-size Standard_B2s

az aks get-credentials -g $RESOURCE_NAME -n $RESOURCE_NAME

echo "Gathering DNS name"

export DNS_NAME=$(az aks show -g $RESOURCE_NAME -n $RESOURCE_NAME -o tsv --query addonProfiles.httpApplicationRouting.config.HTTPApplicationRoutingZoneName)
sed -i '' 's+!DNS!+'"$DNS_NAME"'+g' ./ingress.yaml

kubectl apply -f https://raw.githubusercontent.com/Azure-Samples/mslearn-aks-application-scalability/main/kubernetes/deployment.yaml
kubectl apply -f https://raw.githubusercontent.com/Azure-Samples/mslearn-aks-application-scalability/main/kubernetes/ingress.yaml
kubectl apply -f https://raw.githubusercontent.com/Azure-Samples/mslearn-aks-application-scalability/main/kubernetes/service.yaml
