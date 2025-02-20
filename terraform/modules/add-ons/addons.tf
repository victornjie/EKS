#####################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
#
# Version: 1.0.1
######################################################################

# This module deploys an EKS Add-on

resource "aws_eks_addon" "eks_add_on" {
  for_each = var.addon_name
  cluster_name  = var.cluster_name
  addon_name    = each.value
  addon_version = var.addon_version
}