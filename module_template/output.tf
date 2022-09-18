# Outputs are import if you wish to use any resources created by this module, by the root code,
# or other modules.

# For example, to use the following value by the root code (or for the root code to pass into
# another module), it would refer to the below as: 
#    module.whatever_it_called_this_module.gcp_project_number

output "gcp_project_number" {
    description = "GCP Project number"
    value = google_project.gcp_project.number
}