#! /bin/bash

# variables
PROJECT_ID=$(gcloud config get-value project)
GKE_PROD_CLUSTER_NAME=cymbal-bank-prod
GKE_DEV_CLUSTER_NAME=cymbal-bank-dev
ZONE=us-central1-a
CONTEXT_PROD=gke_qwiklabs-gcp-02-7f381c0aae13_us-central1-a_cymbal-bank-prod
CONTEXT_DEV=gke_qwiklabs-gcp-02-7f381c0aae13_us-central1-a_cymbal-bank-dev

# NOTE !!!!!!!!!!!!!!!!!!!!!!
# Use this command to list out all the contexts in your kube config
# kubectl config get-contexts --output name
# ---------------------------

# stop all application deployments to have the pods restart themselves
kubectl --context=$CONTEXT_PROD rollout restart deployment
kubectl --context=$CONTEXT_DEV rollout restart deployment

# NOTE !!!!!!!!!!!!!!!!!!!!!!!!!
# Make sure to look at all the pods to see if they actually restarted.
# Restart manually any that weren't part of these deployments
# -------------------------------
