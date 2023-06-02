#! /bin/bash

# variables
PROJECT_ID=$(gcloud config get-value project)
ZONE=us-central1-a
GKE_PROD_CLUSTER_NAME=cymbal-bank-prod
GKE_DEV_CLUSTER_NAME=cymbal-bank-dev
CONFIG_MAP_NAME=asm-options
CONTEXT_PROD=gke_qwiklabs-gcp-02-7f381c0aae13_us-central1-a_cymbal-bank-prod
CONTEXT_DEV=gke_qwiklabs-gcp-02-7f381c0aae13_us-central1-a_cymbal-bank-dev

# NOTE !!!!!!!!!!!!!!!!!!!!!!
# Use this command to list out all the contexts in your kube config
# kubectl config get-contexts --output name
# ---------------------------

# needed when getting CIDRS
function join_by { local IFS="$1"; shift; echo "$*"; }

# create the configmap for multicluster on prod
kubectl --context=$CONTEXT_PROD create configmap $CONFIG_MAP_NAME -n istio-system --from-literal multicluster_mode=connected

# create the configmap for multicluster on dev
kubectl --context=$CONTEXT_DEV create configmap $CONFIG_MAP_NAME -n istio-system --from-literal multicluster_mode=connected

# create remote secret for prod
PRIV_IP_PROD=`gcloud container clusters describe "${GKE_PROD_CLUSTER_NAME}" \
  --zone "${ZONE}" --format "value(privateClusterConfig.privateEndpoint)"`

../asm/istioctl x create-remote-secret --context=${CONTEXT_PROD} --name=${GKE_PROD_CLUSTER_NAME} --server=https://${PRIV_IP_PROD} > ${CONTEXT_PROD}.secret

# create remote secret for dev
PRIV_IP_DEV=`gcloud container clusters describe "${GKE_DEV_CLUSTER_NAME}" \
  --zone "${ZONE}" --format "value(privateClusterConfig.privateEndpoint)"`

../asm/istioctl x create-remote-secret --context=${CONTEXT_DEV} --name=${GKE_DEV_CLUSTER_NAME} --server=https://${PRIV_IP_DEV} > ${CONTEXT_DEV}.secret

# apply the remote secrets
kubectl apply -f ${CONTEXT_PROD}.secret --context=${CONTEXT_DEV}
kubectl apply -f ${CONTEXT_DEV}.secret --context=${CONTEXT_PROD}
