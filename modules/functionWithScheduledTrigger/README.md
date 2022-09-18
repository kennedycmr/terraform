# Overview

This module will deploy a new Cloud Function (CF) in a GCP project. The CF will be deployed along with
 a cloud scheduler that will trigger the CF on a defined schedule, via a message published to a Pub/Sub topic.


## Quick start

* Copy the "functionWithScheduledTrigger" folder to the "./terraform/modules" folder, where "./terraform" is where you root Terraform configuration files are found.

* In your main.tf include the following: 
```
module "my_name_function" {
  source                      = "./modules/functionWithScheduledTrigger"
  GCP_PROJECT_ID              = var.GCP_PROJECT_ID
  GCP_DEFAULT_REGION          = var.GCP_DEFAULT_REGION
  CLOUDFUNCTION_SRC_DIRECTORY = "../cloudfunctionSource"
  CLOUDFUNCTION_NAME          = "name-for-my-function"
  CLOUDFUNCTION_RUN_SA_EMAIL  = google_service_account.sa_run.email
  CLOUDFUNCTION_CRON_SCHEDULE = "5 7-17 * * *"
  CLOUDFUNCTION_ENV_VARS = {
    "functionName"          = "name-for-my-function"
    "gcpRegion"             = var.GCP_DEFAULT_REGION
    "gcpProjectId"          = data.google_project.gcp_project.project_id
    "loggingOnGCPInfra"     = "True"
  }
}
```

* Run terraform validate and fix any issues that appear.    

* Run terraform plan and confirm you are ok with what will be deployed.   

* Run terraform apply to have the resources deployed.


## Inputs

Refer to the variables.tf file for the required and optional inputs.

## Outputs

There are no outputs from this module.


## Notes

* Running this module in a project with existing resources will not cause problems, so long as the name given for the cloud function doesn't already exist. The cloud function name is also used to name the pub/sub topic and the cloud schedule.

