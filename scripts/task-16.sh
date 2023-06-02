#! /bin/bash

# variables
PROJECT_ID=$(gcloud config get-value project)
ZONE=us-central1-a
GKE_DEV_CLUSTER_NAME=cymbal-bank-dev
OUTPUT_DIR=../asm
ASMCLI_INSTALL_URL=https://storage.googleapis.com/csm-artifacts/asm/asmcli_1.16 
ASMCLI_CMD=./asmcli
ISTIO_REV=asm-1172-1
NAMESPACE=default

# download asmcli fresh to use it
curl $ASMCLI_INSTALL_URL > $ASMCLI_CMD
chmod 755 $ASMCLI_CMD

# install ASM on the development cluster
$ASMCLI_CMD install \
  --project_id $PROJECT_ID \
  --cluster_name $GKE_DEV_CLUSTER_NAME \
  --cluster_location $ZONE \
  --output_dir $OUTPUT_DIR \
  --enable_all \
  --ca mesh_ca

# get kubectl context for this cluster
gcloud container clusters get-credentials $GKE_DEV_CLUSTER_NAME \
  --project=$PROJECT_ID --zone=$ZONE

# NOTE!!!!!!!!!!!!!!!!!!!!
# Make sure the ISTIO_REV is correct by running this on the prod cluster after ASM install
# Look for the 'istio.io/rev' label
# kubectl get pods -n istio-system --show-labels

# Add sidecar injection to all our namespaces
# NOTE: don't worry if it couldn't find istio-injection, we're just trying to remove it IF it's there
kubectl label namespace $NAMESPACE istio-injection- istio.io/rev=$ISTIO_REV --overwrite

# restart all pods
kubectl rollout restart deployment