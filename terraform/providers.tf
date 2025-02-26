#####################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
#
# Version: 1.0.1
######################################################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.52.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = "us-east-1"
  profile = "mgmt"
}

provider "aws" {
  region  = "us-east-2"
  profile = "network-hub"
  alias   = "hub-us-east-2"
}

provider "aws" {
  region  = "us-east-1"
  profile = "network-hub"
  alias   = "hub-us-east-1"
}