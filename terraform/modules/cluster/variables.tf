#####################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
#
# Version: 1.0.1
######################################################################

variable "name" {
  description = "The name of the Rancher Management EKS cluster"
  type = string
  default = "rancher_management_cluster"
}

variable "version" {
  description = "Desired Kubernetes master version"
  type = string
  default = "1.32"
}

variable "role_arn" {
  description = "ARN of the IAM role that provides permissions for the EKS control plane to make calls to AWS API operations on your behalf"
  type = string
  default = "10.100.100.0/24"
}

variable "authentication_mode" {
  description = "The desired authentication mode for the cluster"
  type = string
  default = "API_AND_CONFIG_MAP"

  validation {
    condition     = contains(["API_AND_CONFIG_MAP", "API", "CONFIG_MAP"], var.cluster_auth_mode)
    error_message = "Allowed values are 'API_AND_CONFIG_MAP', 'API', or 'CONFIG_MAP'"
  }
}

variable "bootstrap_cluster_creator_admin_permissions" {
  description = "Specifies whether or not the cluster creator IAM principal was set as a cluster admin access entry during cluster creation time"
  type = bool
  default = true
}

variable "key_arn" {
  description = "ARN of the Key Management Service (KMS) customer master key (CMK). The CMK must be symmetric"
  type = string
  default = "arn:aws:kms:us-east-1:288761757752:key/25c0a172-ed8b-4ef1-8d5e-98df0d9a9863"
}

variable "ip_family" {
  description = "The IP family used to assign Kubernetes pod and service addresses"
  type = string
  default = "ipv4"

  validation {
    condition     = contains(["ipv4", "ipv6"], var.ip_family)
    error_message = "Allowed values are 'ipv4' or 'ipv6'"
  }
}

variable "service_ipv4_cidr" {
  description = "The CIDR block to assign Kubernetes pod and service IP addresses from"
  type = string
  default = "10.100.100.0/24"
}

variable "security_group_ids" {
  description = "Optional list of security group IDs for communication between worker nodes and the Kubernetes control plane"
  type = list(string)
  default = []
}

variable "subnet_ids" {
  description = "List of subnet IDs. Must be in at least two different availability zones"
  type = list(string)
  default = []
}

variable "endpoint_private_access" {
  description = "Specify whether the Amazon EKS private API server endpoint is enabled"
  type = bool
  default = true
}

variable "endpoint_public_access" {
  description = "Specify whether the Amazon EKS public API server endpoint is enabled"
  type = bool
  default = true
}

variable "support_type" {
  description = "Specify whether extended support is enabled or disabled for the cluster"
  type = string
  default = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "EXTENDED"], var.cluster_support_type)
    error_message = "Allowed values are 'STANDARD' or 'EXTENDED'"
  }
}

variable "enabled_cluster_log_types" {
  description = "List of the desired control plane logging to enable for the cluster"
  type = list(string)
  default = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  validation {
    condition     = contains(["api", "audit", "authenticator", "controllerManager", "scheduler"], var.cluster_logging)
    error_message = "Allowed values are 'api', 'audit', 'authenticator', 'controllerManager', 'scheduler'"
  }
}

variable "user_defined_tags" {
  type = map(string)
  validation {
    condition = alltrue([
      for k, v in var.user_defined_tags :
      substr(k, 0, 4) != "aws:"
      && can(regex("^[\\w\\s_.:=+-@/]{0,128}$", k))
    && can(regex("^[\\w\\s_.:=+-@/]{0,256}$", v))])
    error_message = "Must match the allowable values for a Tag Key/Value. The Key must NOT begin with 'aws:'. Both can only contain alphanumeric characters or specific special characters _.:/=+-@ up to 128 characters for Key and 256 characters for Value."
  }
}