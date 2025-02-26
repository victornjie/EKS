#####################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
#
# Version: 1.0.1
######################################################################

output "eks_cluster_name" {
  description = "Name of the cluster"
  value       = aws_eks_cluster.eks_cluster.id
}

output "eks_cluster_arn" {
  description = "ARN of the cluster"
  value       = aws_eks_cluster.eks_cluster.arn
}

output "eks_cluster_version" {
  description = "Platform version for the cluster"
  value       = aws_eks_cluster.eks_cluster.platform_version
}

output "kms_key_arn" {
  description = "The ARN of the KMS key"
  value = aws_kms_key.kms_key.arn
}

output "kms_key_id" {
  description = "The ID of the KMS key"
  value = aws_kms_key.kms_key.key_id
}