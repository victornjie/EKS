#####################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
#
# Version: 1.0.1
######################################################################

module "eks_cluster" {
  source = "./modules/cluster"

  cluster_name               = var.cluster_name
  cluster_subnet_ids         = var.cluster_subnet_ids
  user_defined_tags          = var.user_defined_tags
  cluster_key_admin_role_arn = var.cluster_key_admin_role_arn
  cluster_kms_key_name       = var.cluster_kms_key_name
  principal_arn              = var.principal_arn
}


module "eks_node_group" {
  source = "./modules/node-group"

  cluster_name            = module.eks_cluster.eks_cluster_name
  node_group_name         = var.node_group_name
  node_subnet_ids         = var.node_subnet_ids
  desired_size            = var.desired_size
  max_size                = var.max_size
  min_size                = var.min_size
  user_defined_tags       = var.user_defined_tags
  instance_type           = var.instance_type
  node_key_admin_role_arn = var.node_key_admin_role_arn
  node_kms_key_name       = var.node_kms_key_name

  depends_on = [module.eks_cluster]
}