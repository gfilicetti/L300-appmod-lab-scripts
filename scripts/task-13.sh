#! /bin/bash

# variables
PROJECT_ID=$(gcloud config get-value project)
PROJECT_NUM=$(gcloud projects describe ${PROJECT_ID} --format json | jq -r .projectNumber)
ZONE=us-central1-a
CLOUD_BUILD_SA="serviceAccount:${PROJECT_NUM}@cloudbuild.gserviceaccount.com"
GKE_PROD_CLUSTER_NAME=cymbal-bank-dev
GSR_REPO_NAME=cymbal-bank-repo
GSR_REPO_DIR=cymbal-bank-gsr
GSR_BRANCH_NAME=cymbal-dev
TRIGGER_NAME="deploy-cymbal-k8s-dev"
BUILD_CONFIG_FILE="cloud-build-dev.yaml"

# This isn't needed because we gave permissions in Step 11 already
# # give cloud build SA permissions to deploy to GKE
# gcloud projects add-iam-policy-binding $PROJECT_ID \
#   --member="${CLOUD_BUILD_SA}" \
#   --role="roles/container.admin"

# Create a 'cymbal-dev' branch on the GSR repo
cd $GSR_REPO_DIR
git checkout -b $GSR_BRANCH_NAME

# copy cloud-build.yaml to the root of the GSR repo
cp ../$BUILD_CONFIG_FILE .

# copy the v2 version of frontend.yaml to the kubernetes-manifest folder in the GSR repo
cp ../../kubernetes-manifests/frontend.yaml.v2 ./kubernetes-manifests/frontend.yaml

# NOTE !!!!!!!!!!!!!!!!!!!
# You need to have a valid gitconfig with name and email already set up. Run can run these commands first:
# git config --global user.email "you@example.com"
# git config --global user.name "Your Name"
# ------------------------

# add, commit and push these new files
git add *
git commit -m "Adding dev version of cloud build yaml and v2 of frontend"
git push --set-upstream origin $GSR_BRANCH_NAME
cd ..

# NOTE !!!!!!!!!!!!!!!!!!!!
# Make sure that the v2 version of frontend.yaml is in the GSR or it will fail
# Make sure that cloud-build-dev.yaml is in the root of the GSR repo or this trigger won't find it
# Make sure that frontend.yaml and cloud-build-dev.yaml are on the cymbal-dev branch
# --------------------------

# set up the cloud build trigger to run on everything that gets checked into main
gcloud builds triggers create cloud-source-repositories --name=$TRIGGER_NAME \
  --build-config=$BUILD_CONFIG_FILE \
  --repo=$GSR_REPO_NAME \
  --branch-pattern="^cymbal-dev$"
