## Required Variables
variable "GCP_PROJECT_ID" {
  description = "GCP Project Id"
  type        = string
}


variable "GCP_DEFAULT_REGION" {
  description = "Default region to create resources where applicable."
  type        = string
}


## Optional Variables
variable "WEB_APP_NAME" {
  description = "Name assigned to the Firebase Web App that is created"
  type        = string
  default     = "App in a Box"
}


variable "STORAGE_BUCKET_LOCATION" {
  description = "Location where the Storage Bucket will be created."
  type        = string
  default     = "US"
}


variable "STORAGE_BUCKET_NAME_PREFIX" {
  description = "Prefix given to the Storage Bucket created for Firebase. Will be appended with -{GCP_PROJECT_ID}"
  type        = string
  default     = "fb-webapp-bucket"
}


## Do not change the below unless you know what you are doing.
variable "PROJECT_API" {
  description = "Project APIs to Enable"
  type        = set(string)
  default = [
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "appengine.googleapis.com",
    "firebase.googleapis.com",
    "secretmanager.googleapis.com",
    "iamcredentials.googleapis.com",
    "containerregistry.googleapis.com",
    "firestore.googleapis.com"
  ]
}


variable "APPSPOT_ROLES" {
  description = "IAM Roles to Grant to Google AppSpot Service Account"
  type        = set(string)
  default = [
    "firebase.developAdmin",
    "secretmanager.secretAccessor",
    "iam.serviceAccountTokenCreator",
    "logging.logWriter"
  ]
}
