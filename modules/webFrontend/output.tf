output "google_app_engine_application-id" {
  value = google_app_engine_application.app.id
}

output "google_app_engine_application-name" {
  value = google_app_engine_application.app.name
}

output "google_app_engine_application-default_hostname" {
  value = google_app_engine_application.app.default_hostname
}


output "google_firebase_project-id" {
  value = google_firebase_project.default.id
}


output "google_firebase_web_app-id" {
  value = google_firebase_web_app.basic.id
}

output "google_firebase_web_app-name" {
  value = google_firebase_web_app.basic.name
}

output "google_firebase_web_app-app_id" {
  value = google_firebase_web_app.basic.app_id
}



output "google_storage_bucket-id" {
  value = google_storage_bucket.default.id
}

output "google_storage_bucket-self_link" {
  value = google_storage_bucket.default.self_link
}




output "google_storage_bucket_object" {
  value = google_storage_bucket_object.default.self_link
}