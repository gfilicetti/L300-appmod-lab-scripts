#! /bin/bash

# variables
PROJECT_ID=$(gcloud config get-value project)
CLUSTER_NAME=m4a-processing
ZONE=us-central1-a

# create a service account for migrate
gcloud iam service-accounts create m4a-install

# give the service account storage admin rights
gcloud projects add-iam-policy-binding $PROJECT_ID  \
  --member="serviceAccount:m4a-install@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/storage.admin"

# download key file for this service account
gcloud iam service-accounts keys create m4a-install.json \
  --iam-account=m4a-install@$PROJECT_ID.iam.gserviceaccount.com

# connect to the cluster
gcloud container clusters get-credentials $CLUSTER_NAME \
  --zone $ZONE

# set up migrate components on our cluster
migctl setup install --json-key=m4a-install.json

# confirm setup
printf 'Running migctl doctor to confirm deployment\n'
migctl doctor

# NOTE!!!!!!!!!!!!!!!!!!!!!!!
# Keep running migctl doctor until everything but "Source" has a green check
# Source will have a red check until we do Task 3
# ---------------------------