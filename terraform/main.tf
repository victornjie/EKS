#####################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
#
# Version: 1.0.1
######################################################################

module "eks_cluster" {
  source = "./modules/cluster"

  notifier_iam_role_name          = local.notifier_iam_role_name
  aws_org_id                      = local.aws_org_id
  s3_bucket_name                  = local.s3_bucket_name
  s3_bucket_prefix                = local.s3_bucket_prefix
  admin_email_address             = local.admin_email_address
  notifier_lambda_function_name   = local.notifier_lambda_function_name
  smtp_user_param_name            = local.smtp_user_param_name
  smtp_password_param_name        = local.smtp_password_param_name

  providers = {
    aws = aws
  }
}