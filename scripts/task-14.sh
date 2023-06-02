#! /bin/bash

# variables
PROJECT_ID=$(gcloud config get-value project)
ZONE=us-central1-a
GKE_PROD_CLUSTER_NAME=cymbal-bank-prod
OUTPUT_DIR=../asm
ASMCLI_INSTALL_URL=https://storage.googleapis.com/csm-artifacts/asm/asmcli_1.16 
ASMCLI_CMD=./asmcli

# download asmcli fresh to use it
curl $ASMCLI_INSTALL_URL > $ASMCLI_CMD
chmod 755 $ASMCLI_CMD

# install ASM on the production cluster
$ASMCLI_CMD install \
  --project_id $PROJECT_ID \
  --cluster_name $GKE_PROD_CLUSTER_NAME \
  --cluster_location $ZONE \
  --output_dir $OUTPUT_DIR \
  --enable_all \
  --ca mesh_ca
