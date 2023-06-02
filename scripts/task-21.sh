#! /bin/bash

# variables
PROJECT_ID=$(gcloud config get-value project)
ZONE=us-central1-a
GKE_PROD_CLUSTER_NAME=cymbal-bank-prod
GKE_DEV_CLUSTER_NAME=cymbal-bank-dev
FE_INGRESS_FILE=frontend-ingress.yaml
FE_WEIGHTED_INGRESS_FILE=frontend-ingress-weighted.yaml
DESTINATION_RULE_FILE=destination-rule.yaml

# get kubectl context for this cluster
gcloud container clusters get-credentials $GKE_PROD_CLUSTER_NAME \
  --project=$PROJECT_ID --zone=$ZONE

# create the Destination Rule that we'll need for Canary
kubectl apply -f $DESTINATION_RULE_FILE

# Delete the old simple Gateway and a VirtualService 
kubectl delete -f $FE_INGRESS_FILE

# Add a new one with weights
kubectl apply -f $FE_WEIGHTED_INGRESS_FILE
