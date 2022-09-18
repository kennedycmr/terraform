# Add variables here the same way as you would if you weren't creating a module. Any variables not
# given default values will be expected to be passed in by the root calling Terraform code.

variable "GCP_PROJECT_ID" {
  description = "gcp project id where resources will be deployed."
  type        = string
}

