#####################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
#
# Version: 1.0.1
######################################################################

# Creates a Customer Managed (CMK) KMS key to use for encrypting EKS Cluster secrets
resource "aws_kms_key" "cluster_kms_key" {
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kms_key_policy.json
  rotation_period_in_days = 180
  tags = {
    "Name" = var.cluster_kms_key_name
  }
}


# Create AWS EKS Cluster IAM Role
module "cluster_iam_role" {
  source = "../iam-role"

  iam_role_name = "eks_cluster_role"
  principal = "eks.amazonaws.com"
  iam_role_policy_arn = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"]

  depends_on = [aws_kms_key.cluster_kms_key]
}


# Create AWS EKS Cluster

resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = module.cluster_iam_role.iam_role_arn

  access_config {
    authentication_mode                         = var.authentication_mode
    bootstrap_cluster_creator_admin_permissions = var.bootstrap_cluster_creator_admin_permissions
  }

  encryption_config {
    provider {
      key_arn = aws_kms_key.cluster_kms_key.arn
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
    security_group_ids      = var.cluster_security_group_ids
    subnet_ids              = var.cluster_subnet_ids
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


# Create EKS Cluster Access Entry and Access Policy configurations

resource "aws_eks_access_entry" "cluster_access_entry" {
  cluster_name      = aws_eks_cluster.eks_cluster.name
  principal_arn     = var.principal_arn
  kubernetes_groups = var.kubernetes_groups
  type              = var.access_entry_type
}

resource "aws_eks_access_policy_association" "cluster_access_policy" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
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

  depends_on = [aws_eks_cluster.eks_cluster]
}


# Deploy Amazon EKS Add-ons to EKS Cluster
resource "aws_eks_addon" "eks_add_on" {
  for_each      = var.addon_name
  cluster_name  = aws_eks_cluster.eks_cluster.name
  addon_name    = each.value
  addon_version = var.addon_version

  depends_on = [aws_eks_cluster.eks_cluster]
}
