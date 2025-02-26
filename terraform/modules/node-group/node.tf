#####################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
#
# Version: 1.0.1
######################################################################

# Creates a Customer Managed (CMK) KMS key to use for encrypting EBS volumes
resource "aws_kms_key" "node_kms_key" {
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kms_key_policy.json
  rotation_period_in_days = 180
  tags = {
    "Name" = var.node_kms_key_name
  }
}

# This module deploys an EKS Managed Node Group

resource "aws_eks_node_group" "node_group" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = module.node_iam_role.iam_role_arn
  subnet_ids      = var.node_subnet_ids
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


# Create Amazon EKS Node IAM Role
module "node_iam_role" {
  source = "../iam-role"

  iam_role_name = "eks_node_role"
  principal = "ec2.amazonaws.com"
  iam_role_policy_arn = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy", "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy", "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
    ]
  
  depends_on = [aws_kms_key.node_kms_key]
}


# Create EC2 Launch Template for Node Group
module "node_launch_template" {
  source = "../launch-template"

  name = "${var.node_group_name}-launch-template-01"
  device_name       = var.device_name
  volume_size       = var.volume_size
  volume_type       = var.volume_type
  kms_key_id        = aws_kms_key.node_kms_key.arn
  instance_type     = var.instance_type
  security_groups   = var.node_security_groups
  resource_type_tag = var.resource_type_tag
  user_defined_tags = var.user_defined_tags

  depends_on = [module.node_iam_role]
}