#####################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
#
# Version: 1.0.1
######################################################################

# This module deploys an IAM Role

resource "aws_iam_role" "iam_role" {
  name = var.iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = var.principal
        }
      }
    ]
  })

}


resource "aws_iam_role_policy_attachment" "managed_policy_attachment" {
  role       = var.iam_role_name
  count      = length(var.iam_role_policy_arn)
  policy_arn = var.iam_role_policy_arn[count.index]
  depends_on = [aws_iam_role.iam_role]
}