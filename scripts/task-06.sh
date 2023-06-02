#! /bin/bash

# variables
PROJECT_ID=$(gcloud config get-value project)
CLUSTER_NAME=m4a-processing
ZONE=us-central1-a
SOURCE_NAME=m4a-source 
CE_SRC=m4a-ce-src
JOB_NAME=ledgermonolith-migration
VM_NAME=ledgermonolith-service

# now generate artifacts
migctl migration generate-artifacts $JOB_NAME

# check status once before we finish
printf 'Checking status with this command line:\n'
printf "> migctl migration status $JOB_NAME\n"
migctl migration status $JOB_NAME

# NOTE!!!!!!!!!!!!!!!!!!!
# Keep running migration status check until you see Status: Completed
# This needs to be finished before moving to the next step.
# -----------------------   