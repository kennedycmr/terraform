# Import details about the project we will deploy resources to.
data "google_project" "gcp_project" {
  project_id = var.GCP_PROJECT_ID
}


# Enable needed Project APIs
resource "google_project_service" "api" {
  for_each                   = var.PROJECT_API
  project                    = var.GCP_PROJECT_ID
  service                    = each.value
  disable_dependent_services = false
  disable_on_destroy         = false
  timeouts {
    create = "5m"
    update = "5m"
  }
}


# Create random prefix so we can generate out own bucket names
resource "random_id" "id" {
  byte_length = 8
}


# Create the bucket where the source files will be uploaded to
resource "google_storage_bucket" "functionsrc" {
  name                        = "cloudfunctionsrc_${random_id.id.hex}"
  project                     = data.google_project.gcp_project.project_id
  force_destroy               = true
  uniform_bucket_level_access = true
  location                    = var.STORAGE_BUCKET_LOCATION
}


# Archive the source files to prepare them for uploading
data "archive_file" "cloudFunctionSource" {
  type        = "zip"
  source_dir  = var.CLOUDFUNCTION_SRC_DIRECTORY
  output_path = "${path.root}/.terraform/${var.CLOUDFUNCTION_NAME}.zip"
}


# Upload the source file zip to the storage bucket
resource "google_storage_bucket_object" "archive" {
  name   = "${var.CLOUDFUNCTION_NAME}.${data.archive_file.cloudFunctionSource.output_md5}.zip"
  source = data.archive_file.cloudFunctionSource.output_path
  bucket = google_storage_bucket.functionsrc.name
}


# Create the cloud function
resource "google_cloudfunctions_function" "function" {
  name                  = var.CLOUDFUNCTION_NAME
  project               = data.google_project.gcp_project.project_id
  runtime               = var.CLOUDFUNCTION_RUNTIME
  region                = var.GCP_DEFAULT_REGION
  available_memory_mb   = var.CLOUDFUNCTION_MEMORY_MB
  entry_point           = var.CLOUDFUNCTION_ENTRY_POINT
  service_account_email = var.CLOUDFUNCTION_RUN_SA_EMAIL
  source_archive_bucket = google_storage_bucket.functionsrc.name
  source_archive_object = google_storage_bucket_object.archive.name
  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.function.id
    failure_policy {
      retry = false
    }
  }
  environment_variables = var.CLOUDFUNCTION_ENV_VARS
}


# Create the pub/sub topic
resource "google_pubsub_topic" "function" {
  name    = "trigger_function_${var.CLOUDFUNCTION_NAME}"
  project = data.google_project.gcp_project.project_id
}


# Schedule to run data import 
resource "google_cloud_scheduler_job" "import_data_from_sharepoint" {
  project     = data.google_project.gcp_project.project_id
  region      = var.GCP_DEFAULT_REGION
  name        = "trigger_function_${var.CLOUDFUNCTION_NAME}"
  description = "trigger_function_${var.CLOUDFUNCTION_NAME}"
  schedule    = var.CLOUDFUNCTION_CRON_SCHEDULE
  time_zone   = "America/New_York"

  pubsub_target {
    topic_name = google_pubsub_topic.function.id
    data       = base64encode("${var.PUBSUB_MESSAGE}")
  }
}
