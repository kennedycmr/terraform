# In this file, put the usual Terraform code exactly as you would if you weren't creating a module.
# Variables act the same way as usual and are passed into the module from the calling root
# Terraform code.


# Import current project
data "google_project" "gcp_project" {
  project_id = var.GCP_PROJECT_ID
}
