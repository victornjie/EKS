#####################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
#
# Version: 1.0.1
######################################################################

variable "name" {
  description = "The name of the Launch Template"
  type = string
}

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
    error_message = "Allowed values are 'gp3', 'gp2', 'standard'"
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

variable "security_groups" {
  description = "A list of security group IDs to associate"
  type = list(string)
}

variable "resource_type_tag" {
  description = "The type of resource to tag"
  type = set(string)
  default = ["instance", "volume"]
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