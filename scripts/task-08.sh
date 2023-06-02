#! /bin/bash

# variables
PROJECT_ID=$(gcloud config get-value project)
CLUSTER_NAME=m4a-processing
ZONE=us-central1-a
SOURCE_NAME=m4a-source 
CE_SRC=m4a-ce-src
JOB_NAME=ledgermonolith-migration
VM_NAME=ledgermonolith-service
CONFIGMAP_NAME=ledgermonolith-configmap
PROD_CLUSTER_NAME=cymbal-monolith-cluster
ARTIFACT_DIR=artifacts

# create a config map yaml as given
cat <<EOF >> $CONFIGMAP_NAME.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: service-api-config
data:
  # Use Google Compute Engine Internal DNS addresses for ledgermonolith services
  # https://cloud.google.com/compute/docs/internal-dns#instance-fully-qualified-domain-names
  TRANSACTIONS_API_ADDR: "ledgermonolith-service:8080"
  BALANCES_API_ADDR: "ledgermonolith-service:8080"
  HISTORY_API_ADDR: "ledgermonolith-service:8080"
  CONTACTS_API_ADDR: "contacts:8080"
  USERSERVICE_API_ADDR: "userservice:8080"
EOF

# apply the config map
kubectl apply -f $CONFIGMAP_NAME.yaml

# restart all application deployments to have the pods restart themselves
kubectl rollout restart deployment

# NOTE !!!!!!!!!!!!!!!!!!!!!!!!!
# Make sure to look at all the pods to see if they actually restarted.
# Restart manually any that weren't part of these deployments
# -------------------------------