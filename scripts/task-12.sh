#! /bin/bash

# variables
PROJECT_ID=$(gcloud config get-value project)
ZONE=us-central1-a
GKE_DEV_CLUSTER_NAME=cymbal-bank-dev
GKE_DEV_NODES=2
CHANNEL=stable
CP_VERSION=1.23
NODE_VM_TYPE=e2-standard-4

# create the DEV cluster
gcloud container clusters create $GKE_DEV_CLUSTER_NAME \
  --project=$PROJECT_ID --zone=$ZONE \
  --machine-type=$NODE_VM_TYPE --num-nodes=$GKE_DEV_NODES \
  --release-channel=$CHANNEL --cluster-version=$CP_VERSION \
  --monitoring=SYSTEM --logging=SYSTEM,WORKLOAD --subnetwork=default \
  --tags=$GKE_DEV_CLUSTER_NAME --labels csm=

# get kubectl context for this cluster
gcloud container clusters get-credentials $GKE_DEV_CLUSTER_NAME \
  --project=$PROJECT_ID --zone=$ZONE

# move in the manually created v1 of the deployment
mv ../kubernetes-manifests/frontend.yaml ../kubernetes-manifests/frontend.yaml.orig
cp ../kubernetes-manifests/frontend.yaml.v2 ../kubernetes-manifests/frontend.yaml 

# deploy the application to the cluster
kubectl apply -f ../extras/jwt/jwt-secret.yaml
kubectl apply -f ../kubernetes-manifests

# move the original back
mv ../kubernetes-manifests/frontend.yaml.orig ../kubernetes-manifests/frontend.yaml

# NOTE !!!!!!!!!!!!
# Run 'kubectl get pods' and make sure they're all started
# Then run "kubectl get service frontend | awk '{print $4}'" to get the IP address
# ------------------
