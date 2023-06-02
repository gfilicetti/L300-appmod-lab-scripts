#! /bin/bash

# variables
export PROJECT_ID=$(gcloud config get-value project)
export ZONE=us-central1-a
export CLUSTER_NAME=cymbal-monolith-cluster

# deploy the cluster we'll use for production
gcloud container clusters create $CLUSTER_NAME \
  --project=$PROJECT_ID --zone=$ZONE \
  --machine-type=e2-standard-2 --num-nodes=4 \
  --monitoring=SYSTEM --logging=SYSTEM,WORKLOAD --subnetwork=default \
  --tags=$CLUSTER_NAME --labels csm=
