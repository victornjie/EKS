#####################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
#
# Version: 1.0.1
######################################################################

variable "aws_admin_role_arn" {
  description = "The ARN of the AWS Administrator role"
  type = string
}

variable "kms_key_name" {
  description = "The name of the KMS key"
  type = string
}