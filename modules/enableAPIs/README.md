# Overview

This module will enable one or more GCP apis in a specified GCP project.


## Quick start

* Copy the "enableAPIs" folder to the "./terraform/modules" folder, where "./terraform" is where you root Terraform configuration files are found.

* In your main.tf include the following: 
```
module "enable-apis" {
  source         = "./modules/enableAPIs"
  GCP_PROJECT_ID = var.GCP_PROJECT_ID
  PROJECT_API = [
    "logging.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudfunctions.googleapis.com",
    "iam.googleapis.com",
    "cloudscheduler.googleapis.com",
    "bigquery.googleapis.com"
  ]
}
```

* Run terraform validate and fix any issues that appear.    

* Run terraform plan and confirm you are ok with what will be deployed.   

* Run terraform apply to have the resources deployed.

* There is no outputs from this module.


## Notes

* You can run this module fine even if the same API's in the project are already enabled.

* The module is configured to not disable API's or any dependancies on a destroy operation.
