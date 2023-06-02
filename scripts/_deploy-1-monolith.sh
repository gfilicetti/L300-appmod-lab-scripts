#! /bin/bash

# variables
export PROJECT_ID=$(gcloud config get-value project)
export ZONE=us-central1-a
export GCS_BUCKET=bank-of-anthos-ci

# run deploy script
# since we are using the canonical bucket, all the build artifacts will already be there.
../src/ledgermonolith/scripts/deploy-monolith.sh