#! /bin/bash

# variables
PROJECT_ID=$(gcloud config get-value project)
PROJECT_NUM=$(gcloud projects describe ${PROJECT_ID} --format json | jq -r .projectNumber)
ZONE=us-central1-a
CLOUD_BUILD_SA="serviceAccount:${PROJECT_NUM}@cloudbuild.gserviceaccount.com"
GKE_PROD_CLUSTER_NAME=cymbal-bank-prod
GSR_REPO_NAME=cymbal-bank-repo
GSR_REPO_DIR=cymbal-bank-gsr
TRIGGER_NAME="deploy-cymbal-k8s"
BUILD_CONFIG_FILE="cloud-build.yaml"

# give cloud build SA permissions to deploy to GKE
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="${CLOUD_BUILD_SA}" \
  --role="roles/container.admin"

# get the URL of the GSR source repo
GSR_REPO_URL=$(gcloud source repos describe ${GSR_REPO_NAME} --format=json | jq -r .url)

# clone Bank app from the GSR repo into a sibling folder to the github version
git clone $GSR_REPO_URL $GSR_REPO_DIR
cd $GSR_REPO_DIR
git checkout main

# copy cloud-build.yaml to the root of the GSR repo
cp ../$BUILD_CONFIG_FILE .

# copy the v1 version of frontend.yaml to the kubernetes-manifest folder in the GSR repo
cp ../../kubernetes-manifests/frontend.yaml.v1 ./kubernetes-manifests/frontend.yaml

# NOTE !!!!!!!!!!!!!!!!!!!
# You need to have a valid gitconfig with name and email already set up. Run can run these commands first:
# git config --global user.email "you@example.com"
# git config --global user.name "Your Name"
# ------------------------

# add, commit and push these new files
git add *
git commit -m "Adding cloud build file and the v1 of the frontend deployment yaml"
git push --set-upstream origin main
cd ..

# NOTE !!!!!!!!!!!!!!!!!!!!
# Verify the above worked:
# Make sure that the v1 version of frontend.yaml is in the GSR or it will fail
# Make sure that cloud-build.yaml is in the root of the GSR repo or this trigger won't find it
# --------------------------

# set up the cloud build trigger to run on everything that gets checked into main
gcloud builds triggers create cloud-source-repositories --name=$TRIGGER_NAME \
  --build-config=$BUILD_CONFIG_FILE \
  --repo=$GSR_REPO_NAME \
  --branch-pattern="^main$"
