#####################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
#
# Version: 1.0.1
######################################################################

output "ec2_launch_template_id" {
  description = "The ID of the launch template"
  value       = aws_launch_template.ec2_launch_template.id
}

output "ec2_launch_template_name" {
  description = "The name of the launch template"
  value       = aws_launch_template.ec2_launch_template.name
}

output "ec2_launch_template_arn" {
  description = "Amazon Resource Name (ARN) of the launch template"
  value       = aws_launch_template.ec2_launch_template.arn
}

output "ec2_launch_template_latest_version" {
  description = "The latest version of the launch template"
  value       = aws_launch_template.ec2_launch_template.latest_version
}