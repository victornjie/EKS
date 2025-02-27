#####################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
#
# Version: 1.0.1
######################################################################

# Create Security Group for AWS EKS Cluster and Node Group
resource "aws_security_group" "eks_security_group" {
  name        = "eks-security-group"
  description = "Security group for communication between worker nodes and the Kubernetes control plane"
  vpc_id      = var.vpc_id

  tags = {
    Name = "eks-security-group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_security_rules" {
  for_each          = var.ingress_rules
  security_group_id = aws_security_group.eks_security_group.id
  description       = each.value.description
  cidr_ipv4         = each.value.cidr_blocks
  from_port         = each.value.from_port
  ip_protocol       = each.value.protocol
  to_port           = each.value.to_port
}

resource "aws_vpc_security_group_egress_rule" "egress_security_rules_ipv4" {
  security_group_id = aws_security_group.eks_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "egress_security_rules_ipv6" {
  security_group_id = aws_security_group.eks_security_group.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
}


# Create AWS EKS Cluster
module "eks_cluster" {
  source = "./modules/cluster"

  cluster_name               = var.cluster_name
  cluster_subnet_ids         = var.cluster_subnet_ids
  user_defined_tags          = var.user_defined_tags
  cluster_key_admin_role_arn = var.cluster_key_admin_role_arn
  cluster_kms_key_name       = var.cluster_kms_key_name
  principal_arn              = var.principal_arn
  eks_security_group_ids     = [aws_security_group.eks_security_group.id, "sg-015f67624924477e4"]

  depends_on = [aws_security_group.eks_security_group]
}

# Create AWS EKS Managed Node Group
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
  eks_security_group_ids  = [aws_security_group.eks_security_group.id, "sg-015f67624924477e4"]


  depends_on = [module.eks_cluster]
}


# Deploy Additional AWS EKS Add-ons to EKS Cluster
resource "aws_eks_addon" "eks_add_on" {
  for_each      = var.addon_name
  cluster_name  = module.eks_cluster.eks_cluster_name
  addon_name    = each.value

  depends_on = [module.eks_node_group]
}


# Configure AWS EKS Custom Networking
resource "kubectl_manifest" "eni_config" {
  for_each = var.pod_subnet_ids

  yaml_body = yamlencode({
    apiVersion = "crd.k8s.amazonaws.com/v1alpha1"
    kind       = "ENIConfig"
    metadata = {
      name = each.value.availability_zone
    }
    spec = {
      securityGroups = [
        aws_security_group.eks_security_group.id
      ]
      subnet = each.value.subnet_id
    }
  })

  depends_on = [module.eks_cluster]
}