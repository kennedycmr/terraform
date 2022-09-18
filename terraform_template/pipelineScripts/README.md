# What is in this folder?

The files in this folder are bash scripts called by the Bitbucket 
pipeline process. The scripts configure the pipeline container and 
setup terraform and run terraform. They leverage Bitbucket deployment 
variables to ensure the pipeline runs in a specific way. 

Refer to the ./bitbucket-pipelines.yml file for the order the scripts are called. 