#! /bin/bash

# variables
PROJECT_ID=$(gcloud config get-value project)
CLUSTER_NAME=m4a-processing
ZONE=us-central1-a
SOURCE_NAME=m4a-source 
CE_SRC=m4a-ce-src
JOB_NAME=ledgermonolith-migration
VM_NAME=ledgermonolith-service
PROD_CLUSTER_NAME=cymbal-monolith-cluster
ARTIFACT_DIR=artifacts

# NOTE !!!!!!!!!!!!!!
# Once Step 6 is fully complete, go to Container Registry in the Console, go to Settings and make it public
# Otherwise you'll get ImageBackOff errors
# -------------------

# get credential for the processing cluster so we can use migctl
gcloud container clusters get-credentials $CLUSTER_NAME \
  --project=$PROJECT_ID --zone=$ZONE

# download the artifacts to disk
migctl migration get-artifacts $JOB_NAME -d $ARTIFACT_DIR

# switch to our prod cluster now
gcloud container clusters get-credentials $PROD_CLUSTER_NAME \
  --project=$PROJECT_ID --zone=$ZONE

# kubectl apply that to the current cluster
kubectl apply -f artifacts/deployment_spec.yaml
