#####################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
#
# Version: 1.0.1
######################################################################

# EKS cluster variables
variable "cluster_name" {
  description = "The name of the EKS cluster"
  type = string
}

variable "cluster_version" {
  description = "Desired Kubernetes master version"
  type = string
  default = "1.32"
}

variable "authentication_mode" {
  description = "The desired authentication mode for the cluster"
  type = string
  default = "API_AND_CONFIG_MAP"

  validation {
    condition     = contains(["API_AND_CONFIG_MAP", "API", "CONFIG_MAP"], var.authentication_mode)
    error_message = "Allowed values are 'API_AND_CONFIG_MAP', 'API', or 'CONFIG_MAP'"
  }
}

variable "bootstrap_cluster_creator_admin_permissions" {
  description = "Specifies whether or not the cluster creator IAM principal was set as a cluster admin access entry during cluster creation time"
  type = bool
  default = true
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

variable "cluster_security_group_ids" {
  description = "Optional list of security group IDs for communication between worker nodes and the Kubernetes control plane"
  type = list(string)
  default = []
}

variable "cluster_subnet_ids" {
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
    condition     = contains(["STANDARD", "EXTENDED"], var.support_type)
    error_message = "Allowed values are 'STANDARD' or 'EXTENDED'"
  }
}

variable "enabled_cluster_log_types" {
  description = "List of the desired control plane logging to enable for the cluster"
  type = list(string)
  default = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  validation {
    condition     = contains(["api", "audit", "authenticator", "controllerManager", "scheduler"], var.enabled_cluster_log_types)
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

# KMS key module variables
variable "cluster_key_admin_role_arn" {
  description = "The ARN of the AWS KMS key Administrator role"
  type = string
}

variable "cluster_kms_key_name" {
  description = "The name of the KMS key"
  type = string
  default = "eks-kms-key"
}

# EKS cluster access variables

variable "principal_arn" {
  description = "The IAM Principal ARN which requires Authentication access to the EKS cluster"
  type = string
}

variable "kubernetes_groups" {
  description = "Optionally specify the Kubernetes groups the user would belong to when creating an access entry"
  type = list(string)
  default = null
}

variable "access_entry_type" {
  description = "The desired authentication mode for the cluster"
  type = string
  default = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "EC2_LINUX", "EC2_WINDOWS", "FARGATE_LINUX"], var.access_entry_type)
    error_message = "Allowed values are 'STANDARD', 'EC2_LINUX', 'EC2_WINDOWS', or 'FARGATE_LINUX'"
  }
}

variable "policy_arn" {
  description = "The ARN of the access policy that you're associating"
  type = string
  default = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
}

variable "access_scope_type" {
  description = "The scope of an AccessPolicy that's associated to an AccessEntry"
  type = string
  default = "cluster"

  validation {
    condition     = contains(["cluster", "namespace"], var.access_scope_type)
    error_message = "Allowed values are 'cluster' or 'namespace'"
  }
}

variable "namespaces" {
  description = "The namespaces to which the access scope applies when type is namespace"
  type = list(string)
  default = null
}

# EKS cluster add-ons variables
variable "addon_name" {
  description = "Name of the EKS add-on"
  type = set(string)
  default = ["vpc-cni", "coredns", "kube-proxy", "aws-ebs-csi-driver", "aws-efs-csi-driver", "eks-pod-identity-agent"]
}

variable "addon_version" {
  description = "The version of the EKS add-on"
  type = string
  default = null
}