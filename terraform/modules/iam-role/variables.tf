#####################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
#
# Version: 1.0.1
######################################################################

variable "iam_role_policy_arn" {
  description = "IAM Policy to be attached to role"
  type = list
}

variable "iam_role_name" {
  description = "IAM role name"
  type = string
}

variable "principal" {
  description = "The service principal to assume the IAM role"
  type = string

  validation {
    condition     = contains(["ec2.amazonaws.com", "eks.amazonaws.com"], var.principal)
    error_message = "Allowed values are 'ec2.amazonaws.com' or 'eks.amazonaws.com'"
  }
}