#! /bin/bash

# variables
PROJECT_ID=$(gcloud config get-value project)
CLUSTER_NAME=m4a-processing
ZONE=us-central1-a
SOURCE_NAME=m4a-source 
CE_SRC=m4a-ce-src
JOB_NAME=ledgermonolith-migration
VM_NAME=ledgermonolith-service

# NOTE!!!!!!!!!!!!!!!!!!!
# Check migration status and wait until you see it as Status: Completed
# -----------------------

# download the migration plan
migctl migration get $JOB_NAME

# NOTE!!!!!!!!!!!!!!!!!!!!
# Make sure that the dataVolumes bit isn't put in twice at the end of the yaml file
# ------------------------
# edit $JOB_NAME.yaml and add our data volumes to the end
cat <<EOF >> $JOB_NAME.yaml
  dataVolumes:
    - folders:
      - /var/lib/postgresql
EOF

# update the revised plan
migctl migration update $JOB_NAME --main-config $JOB_NAME.yaml

# check status once before we finish
printf 'Checking status with this command line:\n'
printf "> migctl migration status $JOB_NAME\n"
migctl migration status $JOB_NAME