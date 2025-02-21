#####################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
#
# Version: 1.0.1
######################################################################

# This module deploys an EKS cluster

resource "aws_eks_cluster" "eks_cluster" {
  name     = var.name
  version  = var.version
  role_arn = var.role_arn

  access_config {
    authentication_mode                         = var.authentication_mode
    bootstrap_cluster_creator_admin_permissions = var.bootstrap_cluster_creator_admin_permissions
  }

  encryption_config {
    provider {
      key_arn = var.key_arn
    }
    resources = ["secrets"]
  }

  dynamic "kubernetes_network_config" {
    for_each = var.ip_family == "ipv4" ? [1]:[0]
    content {
      ip_family         = var.ip_family
      service_ipv4_cidr = var.service_ipv4_cidr
    }
  }

  dynamic "kubernetes_network_config" {
    for_each = var.ip_family == "ipv6" ? [1]:[0]
    content {
      ip_family         = var.ip_family
    }
  }

  vpc_config {
    security_group_ids      = var.security_group_ids
    subnet_ids              = var.subnet_ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
  }

  upgrade_policy {
    support_type = var.support_type
  }

  enabled_cluster_log_types = var.enabled_cluster_log_types

  tags = var.user_defined_tags

  depends_on = [module.cluster_iam_role]
}

# Create Amazon EKS Cluster IAM Role
module "cluster_iam_role" {
  source = "../iam-role"

  iam_role_name = "eks_cluster_role"
  principal = "eks.amazonaws.com"
  iam_role_policy_arn = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"]
}

# Deploy Amazon EKS Add-ons to Cluster
module "eks_add_on" {
  source = "../add-ons"

  cluster_name = var.name

  depends_on = [aws_eks_cluster.eks_cluster]
}
