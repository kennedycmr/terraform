## Required Variables
variable "GCP_PROJECT_ID" {
  description = "GCP Project Id"
  type        = string
}

variable "GCP_DEFAULT_REGION" {
  description = "GCP Region to deploy resources to"
  type        = string
}

variable "CLOUDFUNCTION_SRC_DIRECTORY" {
  description = "Path to cloud function source files, relative to Terraform root directory"
  type        = string
}

variable "CLOUDFUNCTION_NAME" {
  description = "Name to assign to Cloud Function"
  type        = string
}

variable "CLOUDFUNCTION_RUN_SA_EMAIL" {
  description = "Service Account Email to use as run account for function."
  type        = string
}





## Optional Variables
variable "PROJECT_API" {
  description = "Project APIs to Enable"
  type        = set(string)
  default = [
    "logging.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudfunctions.googleapis.com",
    "iam.googleapis.com",
    "cloudscheduler.googleapis.com"
  ]
}

variable "STORAGE_BUCKET_LOCATION" {
  description = "Location where Storage Bucket will reside"
  type        = string
  default     = "US"
}

variable "CLOUDFUNCTION_RUNTIME" {
  description = "Cloud Function runtime to use"
  type        = string
  default     = "python39"
}

variable "CLOUDFUNCTION_MEMORY_MB" {
  description = "Cloud Function memory to assign in MB"
  type        = string
  default     = "512"
}

variable "CLOUDFUNCTION_ENTRY_POINT" {
  description = "Cloud Function entry point"
  type        = string
  default     = "main"
}

variable "CLOUDFUNCTION_ENV_VARS" {
  description = "Set of key/value pairs to assign as environment variables to Cloud Function"
  type        = map(any)
  default     = {}
}

variable "CLOUDFUNCTION_CRON_SCHEDULE" {
  description = "What schedule to trigger function, in cron format. e.g. '5 17 * * *'"
  type        = string
}

variable "PUBSUB_MESSAGE" {
  description = "Message that pub/sub will publish when triggering the Function"
  type        = string
  default     = "run"
}