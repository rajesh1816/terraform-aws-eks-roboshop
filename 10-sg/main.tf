#security group for bastion host
module "bastion" {
  source         = "git::https://github.com/rajesh1816/terraform-sg-module.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = var.bastion_sg_name
  sg_description = var.bastion_sg_description
  vpc_id         = local.vpc_id
}

#ingress rule for bastion sg
resource "aws_security_group_rule" "bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}

# bastion host outbound rule
resource "aws_security_group_rule" "bastion_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"          # all protocols
  cidr_blocks       = ["0.0.0.0/0"] # allow to anywhere
  security_group_id = module.bastion.sg_id
}



#security group for ingress_alb
module "ingress_alb" {
  source         = "git::https://github.com/rajesh1816/terraform-sg-module.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = "ingress-alb"
  sg_description = "for ingress-alb"
  vpc_id         = local.vpc_id
}

# allowing http to ingress_alb from internet
resource "aws_security_group_rule" "ingress_alb_allow_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.ingress_alb.sg_id
}

# allowing https to ingress_alb from internet
resource "aws_security_group_rule" "ingress_alb_allow_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.ingress_alb.sg_id
}

# ingress_alb host outbound rule
resource "aws_security_group_rule" "ingress_alb_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"          # all protocols
  cidr_blocks       = ["0.0.0.0/0"] # allow to anywhere
  security_group_id = module.frontend_alb.sg_id
}


#security group for eks_control_plane 
module "eks_control_plane" {
  source         = "git::https://github.com/rajesh1816/terraform-sg-module.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = "eks-control-plane"
  sg_description = "for eks-control-plane"
  vpc_id         = local.vpc_id
}


# eks control plane allow all traffic from worker nodes
resource "aws_security_group_rule" "eks_control_plane_allow_eks_nodes" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = module.eks_nodes.sg_id
  security_group_id        = module.eks_control_plane.sg_id
}

# eks control plane allow all traffic from worker nodes
resource "aws_security_group_rule" "eks_control_plane_allow_bastion" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.eks_control_plane.sg_id
}

# eks_control_plane  outbound rule
resource "aws_security_group_rule" "ingress_alb_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"          # all protocols
  cidr_blocks       = ["0.0.0.0/0"] # allow to anywhere
  security_group_id = module.eks_control_plane.sg_id
}


#security group for eks_nodes 
module "eks_nodes" {
  source         = "git::https://github.com/rajesh1816/terraform-sg-module.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = "eks-nodes"
  sg_description = "for eks-nodes"
  vpc_id         = local.vpc_id
}


# eks control plane allow all traffic from worker nodes
resource "aws_security_group_rule" "eks_nodes_allow_eks_control_plane" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = module.eks_control_plane.sg_id
  security_group_id        = module.eks_nodes.sg_id
}

# eks control plane allow all traffic from worker nodes
resource "aws_security_group_rule" "eks_nodes_allow_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.eks_nodes.sg_id
}

# eks nodes allow traffic from vpc cidr for pod to pod communication on different nodes
resource "aws_security_group_rule" "eks_nodes_allow_all_traffic_from_vpc_cidr" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  cidr_blocks              = ["10.0.0.0/16"]
  security_group_id        = module.eks_nodes.sg_id
}

# eks_nodes  outbound rule
resource "aws_security_group_rule" "eks_nodes_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"          # all protocols
  cidr_blocks       = ["0.0.0.0/0"] # allow to anywhere
  security_group_id = module.eks_nodes.sg_id
}






