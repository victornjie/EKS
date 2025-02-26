#####################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
#
# Version: 1.0.1
######################################################################

# This module creates an EC2 Launch Template for nodes in an EKS Managed Node Group

resource "aws_launch_template" "ec2_launch_template" {
  name = var.name

  block_device_mappings {
    device_name = var.device_name

    ebs {
      volume_size = var.volume_size
      volume_type = var.volume_type
      encrypted = true
      delete_on_termination = true
      kms_key_id = var.kms_key_id
    }
  }

  instance_type = var.instance_type

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
    instance_metadata_tags      = "enabled"
  }

  network_interfaces {
    description = "EKS connectivity network interface"
    device_index = 0
    delete_on_termination = true
    associate_public_ip_address = false
    security_groups = var.security_groups
  }

  dynamic "tag_specifications" {
    for_each = var.resource_type_tag
    content {
      resource_type = each.value
      tags = var.user_defined_tags
    }
    
  }

  tags = var.user_defined_tags
}