## Required Variables
variable "GCP_PROJECT_ID" {
  description = "GCP Project Id"
  type        = string
}

variable "PROJECT_API" {
  description = "Project APIs to Enable"
  type        = set(string)
}
