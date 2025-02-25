vpc-cni = {
      most_recent = true # false means, use default version
      # addon_version            = "v1.15.1-eksbuild.1"
      # Use Pod Identity
      pod_identity_association = [{
        service_account = local.eks_addon_pod_identity_association.aws_vpc_cni_ipv4.service_account
        role_arn        = data.aws_iam_role.eks_addon_pod_identity_role["aws_vpc_cni_ipv4"].arn
      }]
      # # Use IRSA
      # service_account_role_arn = module.irsa_cni.iam_role_arn

      # Use following if using custom networking using secondary cidr
      before_compute = true
      configuration_values = jsonencode({
        env = {
          AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG = "true"
          ENABLE_POD_ENI                     = "true"
          POD_SECURITY_GROUP_ENFORCING_MODE  = "standard"
          ENI_CONFIG_LABEL_DEF               = "topology.kubernetes.io/zone"
          ENABLE_PREFIX_DELEGATION           = "true"
        }
        init = {
          env = {
            DISABLE_TCP_EARLY_DEMUX = "true"
          }
        }
      })
    }





# TODO, Should we use separate Pod Security Group
# TODO, check latest API version
resource "kubectl_manifest" "eni_config" {
  for_each = { for subnet in data.aws_subnet.pods_subnets : subnet.availability_zone => subnet.id }

  yaml_body = yamlencode({
    apiVersion = "crd.k8s.amazonaws.com/v1alpha1"
    kind       = "ENIConfig"
    metadata = {
      name = each.key
    }
    spec = {
      securityGroups = [
        module.eks.node_security_group_id,
      ]
      subnet = each.value
    }
  })
}
