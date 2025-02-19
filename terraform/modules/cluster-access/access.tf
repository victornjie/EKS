#####################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
#
# Version: 1.0.1
######################################################################

# This module creates Access Entry and Access Policy Configurations for an EKS Cluster

resource "aws_eks_access_entry" "cluster_access_entry" {
  cluster_name      = var.cluster_name
  principal_arn     = var.principal_arn
  kubernetes_groups = var.kubernetes_groups
  type              = var.access_entry_type
}

resource "aws_eks_access_policy_association" "cluster_access_policy" {
  cluster_name  = var.cluster_name
  policy_arn    = var.policy_arn
  principal_arn = var.principal_arn

  dynamic "access_scope" {
    for_each = var.access_scope_type == "namespace" ? [1]:[0]
    content {
      type       = var.access_scope_type
      namespaces = var.namespaces
    }
    
  }

  dynamic "access_scope" {
    for_each = var.access_scope_type == "cluster" ? [1]:[0]
    content {
      type       = var.access_scope_type
    }
    
  }
}