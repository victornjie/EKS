#####################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
#
# Version: 1.0.1
######################################################################

output "node_group_name" {
  description = "The name of the EKS Node Group"
  value       = aws_eks_node_group.node_group.node_group_name
}

output "node_group_arn" {
  description = "The ARN of the EKS Node Group"
  value       = aws_eks_node_group.node_group.arn
}