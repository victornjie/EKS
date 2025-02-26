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

output "node_kms_key_arn" {
  description = "The ARN of the KMS key"
  value = aws_kms_key.node_kms_key.arn
}

output "node_kms_key_id" {
  description = "The ID of the KMS key"
  value = aws_kms_key.node_kms_key.key_id
}