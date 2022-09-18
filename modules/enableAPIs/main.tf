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
