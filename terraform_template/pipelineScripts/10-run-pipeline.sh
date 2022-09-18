#!/bin/bash 

# There are variables we need, and should be set as pipeline variables.
# Make sure we have the correct pipeline variables available
export  PIPELINE_VARIABLES="BITBUCKET_CLONE_DIR
                            BITBUCKET_REPO_SLUG
                            GCP_DEFAULT_REGION
                            GCP_DEPLOYMENT_KEYFILE
                            GCP_PROJECT_ID
                            TERRAFORM_STATE_BUCKET_NAME 
                            TERRAFORM_ACTION"
for VARIABLE in $PIPELINE_VARIABLES; do
    if [ $(set |grep ^"$VARIABLE=" |wc -l) -ne 1 ]; then
        echo "ERROR: Have you set the pipeline variable $VARIABLE?"
        exit 1
    else
        echo "INFO: Found variable $VARIABLE"
    fi
done


# Install OS Dependencies.
apt-get update --allow-releaseinfo-change
apt-get install -y unzip sed wget curl zip


# -------------------------------------------------
#  Authenticating to Google
# -------------------------------------------------

# The docker image we use has the gcloud SDK already installed but we need to configure
# authentication
# Create local temp. keyfile from BB repo. variable we created
echo "INFO: Extracting the deployment key from Bit-Bucket..."
export GCP_KEY_FILE=/root/gcp-deployment-key.json
echo ${GCP_DEPLOYMENT_KEYFILE} | base64 --decode --ignore-garbage > ${GCP_KEY_FILE}

# Configure gcloud to use the deployment key
echo "INFO: Configuring gcloud to the deployment key..."
gcloud auth activate-service-account --key-file ${GCP_KEY_FILE}

# Configure gcloud to use our project we defined in the bb repo variables
echo "INFO: Configuring gcloud to use the GCP Project..."
gcloud config set project ${GCP_PROJECT_ID} --quiet

# Configure gcloud cli
echo "INFO: Displaying active gcloud config list..."
gcloud config list


# -------------------------------------------------
#  Enable APIs
# -------------------------------------------------

# APIs
echo "INFO: Enabling APIs..."
export SERVICES_TO_ENABLE=" cloudresourcemanager,
                            serviceusage"

for SERVICE in $SERVICES_TO_ENABLE; do 
    echo "INFO: Enabling service $SERVICE..."
    gcloud services enable ${SERVICE}.googleapis.com
    echo $?
done




# This is the version of Terraform we will use
export TERRAFORM_VERSION=1.0.9

# Set up GCP project ID
export TF_VAR_GCP_PROJECT_ID=${GCP_PROJECT_ID}

# Setup GCP credentials for Terraform usage
export GOOGLE_APPLICATION_CREDENTIALS=${GCP_KEY_FILE}

echo "INFO: Terraform will use bucket: gs://${TERRAFORM_STATE_BUCKET_NAME}/terraform/state/${BITBUCKET_REPO_SLUG}"
echo "      for it's state file."

# Remove any cached local TF files if there exist this is more for local development
# as we expect the state file to be in GCS. It also shouldnt be committed to source repo.
rm -rf ${BITBUCKET_CLONE_DIR}/terraform/.terraform
rm -rf ${BITBUCKET_CLONE_DIR}/terraform/.terraform.locl.hcl

# Setup Terraform.
echo "INFO: Setting up Terraform environment..."
cd ~
rm -rf terrafor*
wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
export PATH=$PATH:$(pwd)

# Provision Terraform resources.
cd ${BITBUCKET_CLONE_DIR}/terraform

# Download plugins needed for Terraform 
terraform init \
         -backend-config="bucket=${TERRAFORM_STATE_BUCKET_NAME}" \
         -backend-config="prefix=terraform/state/${BITBUCKET_REPO_SLUG}"

# Ensure Terraform syntax is valid before proceeding.
printf '#################     Terraform Validate Stage  ######################################\n\n\n'
terraform validate

# Run Terraform plan to determine what will be changed 
printf '#################     Terraform Plan Stage      ######################################\n\n\n'
terraform plan

# Apply Terraform configuration changes
printf '#################     Terraform Action Stage    ######################################\n\n\n'
echo "INFO: running a ${TERRAFORM_ACTION} action."

if [ "${TERRAFORM_ACTION}" == "plan" ]; then
  echo "Terraform_action set to ${TERRAFORM_ACTION}. Not running apply phase."

elif [ "${TERRAFORM_ACTION}" == "apply" ]; then
  echo "INFO: Running terraform apply"
  terraform ${TERRAFORM_ACTION} -auto-approve

elif [ "${TERRAFORM_ACTION}" == "destroy" ]; then
  echo "INFO: Running terraform destroy"
  terraform ${TERRAFORM_ACTION} -auto-approve

else
  echo "I dont know what to do when TERRAFORM_ACTION = \'${TERRAFORM_ACTION}\'. Check the BB repository variables."
fi
