#! /bin/bash

# variables
PROJECT_ID=$(gcloud config get-value project)
ZONE=us-central1-a
GSR_REPO_NAME=cymbal-bank-repo
GSR_REMOTE_NAME=gsr
GITHUB_REPO_URL=https://github.com/GoogleCloudPlatform/bank-of-anthos.git
GITHUB_REPO_DIR=cymbal-bank-github

# create a new Cloud Source Repository
gcloud source repos create $GSR_REPO_NAME

# get the URL of the new source repo
GSR_REPO_URL=$(gcloud source repos describe ${GSR_REPO_NAME} --format=json | jq -r .url)
printf "The new repo url is: ${GSR_REPO_URL}\n"

# clone Bank app code repo
git clone $GITHUB_REPO_URL $GITHUB_REPO_DIR

# Add the GSR as a remote to the cloned git repo
cd $GITHUB_REPO_DIR
git remote add $GSR_REMOTE_NAME $GSR_REPO_URL

# Push the entire repo to this new remote so we have a copy in GSR
git push $GSR_REMOTE_NAME
