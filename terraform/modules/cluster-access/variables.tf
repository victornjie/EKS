#####################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
#
# Version: 1.0.1
######################################################################

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type = string
}

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
    condition     = contains(["STANDARD", "EC2_LINUX", "EC2_WINDOWS", "FARGATE_LINUX"], var.cluster_access_type)
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
    condition     = contains(["cluster", "namespace"], var.cluster_access_scope)
    error_message = "Allowed values are 'cluster' or 'namespace'"
  }
}

variable "namespaces" {
  description = "The namespaces to which the access scope applies when type is namespace"
  type = list(string)
  default = null
}