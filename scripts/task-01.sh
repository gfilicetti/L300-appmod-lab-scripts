#! /bin/bash

# variables
PROJECT_ID=$(gcloud config get-value project)
CLUSTER_NAME=m4a-processing
ZONE=us-central1-a

# create a single node cluster for processing migration
gcloud container clusters create $CLUSTER_NAME \
    --num-nodes=1 \
    --zone=$ZONE