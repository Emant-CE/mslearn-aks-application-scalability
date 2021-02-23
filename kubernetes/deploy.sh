#!/bin/bash

export GENERAL_NAME=learn-aks-scalability

echo "Creating cluster..."

az group create $GENERAL_NAME -l eastus

az aks create -g $GENERAL_NAME -n $GENERAL_NAME --node-count=1 --generate-ssh-keys --enable-addons http_application_rounting --vm-size Standard_B2s

az aks get-credentials -g $GENERAL_NAME -n $GENERAL_NAME

echo "Gathering DNS name"

export DNS_NAME=$(az aks show -g $GENERAL_NAME -n $GENERAL_NAME -o tsv --query addonProfiles.httpApplicationRouting.config.HTTPApplicationRoutingZoneName)
sed -i '' 's+!DNS!+'"$DNS_NAME"'+g' ./ingress.yaml

kubectl apply -f .
