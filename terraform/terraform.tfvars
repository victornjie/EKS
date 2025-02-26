# EKS cluster variables
cluster_name = "lument-test-cluster"
cluster_subnet_ids = ["subnet-039ebc09f07176501", "subnet-02a74991365e072e3", "subnet-0c0a9c55605c82d4a"]
user_defined_tags = {
  "Environment" : "Demo",
  "Owner" : "VictorMbock"
}

cluster_key_admin_role_arn = "arn:aws:iam::288761757752:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AWSAdministratorAccess_e4b3c38f6337e1cc"
cluster_kms_key_name = "lumen-eks-test-kms-key"

principal_arn = "arn:aws:iam::288761757752:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AWSAdministratorAccess_e4b3c38f6337e1cc"


# EKS node group variables
node_group_name = "lument-test-node"
node_subnet_ids = ["subnet-039ebc09f07176501", "subnet-02a74991365e072e3", "subnet-0c0a9c55605c82d4a"]
desired_size = 3
max_size = 3
min_size = 3
instance_type = "t3.medium"
node_key_admin_role_arn = "arn:aws:iam::288761757752:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AWSAdministratorAccess_e4b3c38f6337e1cc"
node_kms_key_name = "lumen-node-test-kms-key"


