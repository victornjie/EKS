#####################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
#
# Version: 1.0.1
######################################################################

data "aws_partition" "current" {} // Get access to the effective AWS Partition where this module is deployed

data "aws_caller_identity" "current" {} // Get access to the effective Account ID, User ID, and ARN in which Terraform is authorized

data "aws_region" "current" {} // Get access to the effective Region where this module is deployed

data "aws_eks_cluster_auth" "eks" {
  name = module.eks_cluster.eks_cluster_name
}