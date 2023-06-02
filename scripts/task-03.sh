#! /bin/bash

# variables
PROJECT_ID=$(gcloud config get-value project)
CLUSTER_NAME=m4a-processing
ZONE=us-central1-a
SOURCE_NAME=m4a-source 
CE_SRC=m4a-ce-src

# create a service account for VM source migrations
gcloud iam service-accounts create $CE_SRC

# give the service account compute viewer and compute storage admin rights
gcloud projects add-iam-policy-binding $PROJECT_ID  \
  --member="serviceAccount:$CE_SRC@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/compute.viewer"
gcloud projects add-iam-policy-binding $PROJECT_ID  \
  --member="serviceAccount:$CE_SRC@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/compute.storageAdmin"

# download key file for this service account
gcloud iam service-accounts keys create $CE_SRC.json \
  --iam-account=$CE_SRC@$PROJECT_ID.iam.gserviceaccount.com

# create the migration source
migctl source create compute-engine $SOURCE_NAME \
  --json-key=$CE_SRC.json \
  --project=$PROJECT_ID

# confirm setup
printf 'Running migctl doctor to confirm deployment\n'
migctl doctor