# Import details about the project we will deploy resources to.
data "google_project" "google_project" {
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


# Create initial App Engine. NOTE: This is not reversible/destroyable. The only way to decommission
# is to delete the GCP project.
resource "google_app_engine_application" "app" {
  project       = data.google_project.google_project.project_id
  location_id   = var.GCP_DEFAULT_REGION
  database_type = "CLOUD_FIRESTORE"
  depends_on = [
    google_project_service.api["appengine.googleapis.com"]
  ]
}


# Grant IAM roles to the Google Managed App Engine Service Account
resource "google_project_iam_member" "appspot_roles" {
  for_each = var.APPSPOT_ROLES
  project  = var.GCP_PROJECT_ID
  member   = "serviceAccount:${data.google_project.google_project.project_id}@appspot.gserviceaccount.com"
  role     = "roles/${each.value}"
  depends_on = [
    google_project_service.api["appengine.googleapis.com"],
    google_app_engine_application.app
  ]
}


# Create default Firebase Configuration. NOTEL This is not revisable/destroyable. The only way to decommission
# is to delete the GCP project.
resource "google_firebase_project" "default" {
  provider = google-beta
  project  = data.google_project.google_project.project_id
  depends_on = [
    google_project_service.api["firebase.googleapis.com"]
  ]
}


# Create the first Web App
resource "google_firebase_web_app" "basic" {
  provider     = google-beta
  project      = data.google_project.google_project.project_id
  display_name = var.WEB_APP_NAME
  depends_on = [
    google_firebase_project.default
  ]
}


# Apply the Web App config.
data "google_firebase_web_app_config" "basic" {
  provider   = google-beta
  project    = data.google_project.google_project.project_id
  web_app_id = google_firebase_web_app.basic.app_id
}


# Create a Storage bucket to be used for the Web App Config.
resource "google_storage_bucket" "default" {
  provider                    = google-beta
  project                     = data.google_project.google_project.project_id
  uniform_bucket_level_access = true
  force_destroy               = true
  location                    = var.STORAGE_BUCKET_LOCATION
  name                        = "${var.STORAGE_BUCKET_NAME_PREFIX}-${data.google_project.google_project.project_id}"
}


# Create a config file of the Web App and store in our new Bucket.
resource "google_storage_bucket_object" "default" {
  provider = google-beta
  bucket   = google_storage_bucket.default.name
  name     = "firebase-config.json"
  content = jsonencode({
    appId             = google_firebase_web_app.basic.app_id
    apiKey            = data.google_firebase_web_app_config.basic.api_key
    authDomain        = data.google_firebase_web_app_config.basic.auth_domain
    databaseURL       = lookup(data.google_firebase_web_app_config.basic, "database_url", "")
    storageBucket     = lookup(data.google_firebase_web_app_config.basic, "storage_bucket", "")
    messagingSenderId = lookup(data.google_firebase_web_app_config.basic, "messaging_sender_id", "")
    measurementId     = lookup(data.google_firebase_web_app_config.basic, "measurement_id", "")
  })
}
