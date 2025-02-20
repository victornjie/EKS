#####################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
#
# Version: 1.0.1
######################################################################

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type = string
}

variable "addon_name" {
  description = "Name of the EKS add-on"
  type = set(string)
  default = ["vpc-cni", "coredns", "kube-proxy", "aws-ebs-csi-driver", "aws-efs-csi-driver", "eks-pod-identity-agent"]
}

variable "addon_version" {
  description = "The version of the EKS add-on"
  type = string
  default = null
}