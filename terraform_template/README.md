# Overview

This directory is a boilerplate starting point for a new automated pipeline that uses Terraform. The structure is as follows: 

* bitbucket-pipelines.yml (file):  pipeline configuration for Bitbucket, which instructs how to run the automated pipeline.

* pipelineScripts (directory):   where all the scripts are stored that are used exclusively by the pipeline, but not part of the resources being deployed.

* terraform (directory):  where the terraform root files reside.

* test (directory):  used when testing from a local development machine. Scripts that simulate the bitbucket pipeline environment sit here, and are used to start before handing off to the pipelineScripts.


