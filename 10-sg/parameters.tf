resource "aws_ssm_parameter" "bastion_sg_id" {
  name  = "/${var.project}/${var.environment}/bastion-sg-id"
  type  = "String"
  value = module.bastion.sg_id
}

resource "aws_ssm_parameter" "ingress_alb_sg_id" {
  name  = "/${var.project}/${var.environment}/ingress-alb-sg-id"
  type  = "String"
  value = module.ingress_alb.sg_id
}


resource "aws_ssm_parameter" "eks_control_plane_sg_id" {
  name  = "/${var.project}/${var.environment}/eks-control-plane-sg-id"
  type  = "String"
  value = module.eks_control_plane.sg_id
}

resource "aws_ssm_parameter" "eks_nodes_sg_id" {
  name  = "/${var.project}/${var.environment}/eks-nodes-sg-id"
  type  = "String"
  value = module.eks_nodes.sg_id
}

