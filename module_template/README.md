# Overview

This demonstrates a basic boiler plate for a Terraform module and the minimum files and format 
expected.

Ensure you provide a description of how to call this module and what it will do.


# A Note on the "source"

When calling the module, you will have a line that starts with "source". If your module will be 
copied locally to where your root code is, then your source line will be like: 

```
source  = "./modules/your_custom_module"
```
where the path is relative to where the Terraform root configuration files are, and "your_custom_module" and a folder containing your module files, like shown here in this template.


If your module is published on the public Terraform modules registry, then your source line will be like:

```
source  = "vendor_name/repo_name/module_name"
```


# What this module will do

This module will create a ........


## Quick start

To use this module: 
1. 
1.
1.



1. In your main.tf include the following: 
```
module "whatever_name_you_want" {
  source                   = "./modules/your_custom_module"
  project_id               = "gcp_project_id"
}
```
1. Run terraform validate and fix any issues that appear.    
1. Run terraform plan and confirm you are ok with what will be deployed.   
1. Run terraform apply to have the resources deployed.
