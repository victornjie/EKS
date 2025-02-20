#####################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
#
# Version: 1.0.1
######################################################################

# This module deploys an EKS Managed Node Group

resource "aws_eks_node_group" "node_group" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids
  ami_type        = var.ami_type
  capacity_type   = var.capacity_type
  release_version = var.release_version
  

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  update_config {
    max_unavailable = var.max_unavailable
  }

  launch_template {
    id = module.node_launch_template.ec2_launch_template_id
    version = module.node_launch_template.ec2_launch_template_latest_version
  }

  force_update_version = var.force_update_version

  tags = var.user_defined_tags

  depends_on = [module.node_launch_template]
}


# Create EC2 Launch Template for Node Group
module "node_launch_template" {
  source = "../launch-template"

  name = "${var.node_group_name}-launch-template-01"
  device_name       = var.device_name
  volume_size       = var.volume_size
  volume_type       = var.volume_type
  kms_key_id        = var.kms_key_id
  instance_type     = var.instance_type
  security_groups   = var.security_groups
  resource_type_tag = var.resource_type_tag
  user_defined_tags = var.user_defined_tags

}