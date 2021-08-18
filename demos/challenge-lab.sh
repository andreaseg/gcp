#!/bin/bash

# Echo on
set -x

# Create new project
PROJECT_NAME=${PROJECT_NAME:="challenge-lab"}
gcloud projects create --name $PROJECT_NAME --set-as-default -q

# Pause the script to set up billing for the project
read -rsn1 -p"""
    Set up billing for project at https://console.cloud.google.com/billing/projects
    Press any key to continue. Press ^C to abort script.
"""

# Initialize log bucket
LOGS_BUCKET=g://${PROJECT_NAME}-logs-bucket/
gsutil mb $LOGS_BUCKET

# Create compute instance
COMPUTE_INSTANCE= ${COMPUTE_INSTANCE:=PROJECT_NAME}
gcloud compute instances create $COMPUTE_INSTANCE \
    --machine-type e2-micro \
    --metadata-from-file startup-script=startup \
    --metadata lab-logs-bucket=$LOGS_BUCKET \
    --scopes default,storage-full