#!/bin/bash 

### this file only used when developing locally and you want to test the pipeline before
#   sending to bitbucket. 

export BITBUCKET_CLONE_DIR=/workdir
export BITBUCKET_REPO_SLUG=repo-name

# Only remove if/when the tf state files are stored in a remote GCS bucket.
rm -rf ${BITBUCKET_CLONE_DIR}/terraform/.terraform
rm -rf ${BITBUCKET_CLONE_DIR}/terraform/.terraform.lock.hcl


export GCP_DEPLOYMENT_KEYFILE=$(cat ${BITBUCKET_CLONE_DIR}/test/deploy.keys.json |base64)
export GCP_PROJECT_ID=xxxxx
export GCP_DEFAULT_REGION=us-east4
export TERRAFORM_STATE_BUCKET_NAME=terraformstate-${GCP_PROJECT_ID}
export TERRAFORM_ACTION=apply


# Now run the pipelineScripts the same as if bitbucket pipelines was running it.
source ${BITBUCKET_CLONE_DIR}/pipelineScripts/10-run-pipeline.sh
