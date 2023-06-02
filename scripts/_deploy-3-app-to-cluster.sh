#! /bin/bash

# variables
export PROJECT_ID=$(gcloud config get-value project)
export ZONE=us-central1-a
export CLUSTER_NAME=cymbal-monolith-cluster

# get kubectl context for this cluster
gcloud container clusters get-credentials $CLUSTER_NAME \
  --project=$PROJECT_ID --zone=$ZONE

# deploy the application to the cluster
kubectl apply -f ../extras/jwt/jwt-secret.yaml
kubectl apply -f ../kubernetes-manifests

# NOTE !!!!!!!!!!!!
# Run 'kubectl get pods' and make sure they're all started
# Then run "kubectl get service frontend | awk '{print $4}'" to get the IP address
# ------------------