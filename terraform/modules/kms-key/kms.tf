#####################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
#
# Version: 1.0.1
######################################################################

# This module creates a Customer Managed (CMK) KMS key

resource "aws_kms_key" "kms_key" {
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kms_key_policy.json
  rotation_period_in_days = 180
  tags = {
    "Name" = var.kms_key_name
  }
}