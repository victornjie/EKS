#####################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
#
# Version: 1.0.1
######################################################################

#EKS Managed Node Group module variables
variable "cluster_name" {
  description = "The name of the EKS cluster"
  type = string
}

variable "node_group_name" {
  description = "Name of the EKS Node Group"
  type = string
}

variable "node_subnet_ids" {
  description = "Subnets IDs to associate with the EKS Node Group"
  type = list(string)
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  type = number
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type = number
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type = number
}

variable "max_unavailable" {
  description = "(Optional) Desired max number of unavailable worker nodes during node group update"
  type = number
  default = 1
}

variable "ami_type" {
  description = "The AMI type for your node group"
  type = string
  default = "AL2_x86_64"
}

variable "capacity_type" {
  description = "Type of capacity associated with the EKS Node Group"
  type = string
  default = "ON_DEMAND"

  validation {
    condition     = contains(["SPOT", "ON_DEMAND"], var.capacity_type)
    error_message = "Allowed values are 'SPOT' or 'ON_DEMAND'"
  }
}

variable "release_version" {
  description = "(Optional) The AMI version of the EKS Node Group"
  type = string
  default = null
}

variable "force_update_version" {
  description = "(Optional) Force version update if existing pods are unable to be drained due to a pod disruption budget issue"
  type = bool
  default = null
}

variable "user_defined_tags" {
  type = map(string)
  validation {
    condition = alltrue([
      for k, v in var.user_defined_tags :
      substr(k, 0, 4) != "aws:"
      && can(regex("^[\\w\\s_.:=+-@/]{0,128}$", k))
    && can(regex("^[\\w\\s_.:=+-@/]{0,256}$", v))])
    error_message = "Must match the allowable values for a Tag Key/Value. The Key must NOT begin with 'aws:'. Both can only contain alphanumeric characters or specific special characters _.:/=+-@ up to 128 characters for Key and 256 characters for Value."
  }
}

#EC2 Launch Template module variables
variable "device_name" {
  description = "The name of the EBS device to mount (for example, /dev/sdh or xvdh)"
  type = string
  default = "xvdh"
}

variable "volume_size" {
  description = "The size of the EBS volume in gigabytes"
  type = number
  default = 64
}

variable "volume_type" {
  description = "The EBS volume type"
  type = string
  default = "gp3"

  validation {
    condition     = contains(["gp3", "gp2", "standard"], var.volume_type)
    error_message = "Allowed values are 'gp3', 'gp2', or 'standard'"
  }
}

variable "kms_key_id" {
  description = "(Optional) The ARN of the AWS KMS service customer master key (CMK) to use when creating the encrypted volume"
  type = string
  default = null
}

variable "instance_type" {
  description = "The EC2 instance type"
  type = string
}

variable "node_security_groups" {
  description = "A list of security group IDs to associate"
  type = list(string)
  default = null
}

variable "resource_type_tag" {
  description = "The type of resource to tag"
  type = set(string)
  default = ["instance", "volume"]
}

# KMS key module variables
variable "node_key_admin_role_arn" {
  description = "The ARN of the AWS KMS key Administrator role"
  type = string
}

variable "node_kms_key_name" {
  description = "The name of the KMS key"
  type = string
  default = "node-kms-key"
}