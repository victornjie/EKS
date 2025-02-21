#####################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
#
# Version: 1.0.1
######################################################################

output "iam_role_name" {
  description = "The name of the IAM role"
  value       = aws_iam_role.iam_role.name
}

output "iam_role_arn" {
  description = "The ARN of the IAM role"
  value       = aws_iam_role.iam_role.arn
}