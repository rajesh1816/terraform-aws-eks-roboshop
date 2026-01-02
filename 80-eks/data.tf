data "aws_ssm_parameter" "vpc_id" {
  name            = "/${var.project}/${var.environment}/vpc-id"
  with_decryption = true # Set to true for SecureString parameters
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name            = "/${var.project}/${var.environment}/private-subnet-ids"
  with_decryption = true # Set to true for SecureString parameters
}

data "aws_ssm_parameter" "eks_control_plane_sg_id" {
  name            = "/${var.project}/${var.environment}/eks-control-plane-sg-id"
  with_decryption = true # Set to true for SecureString parameters
}

data "aws_ssm_parameter" "eks_nodes_sg_id" {
  name            = "/${var.project}/${var.environment}/eks-nodes-sg-id"
  with_decryption = true # Set to true for SecureString parameters
}