locals {
  vpc_id             = data.aws_ssm_parameter.vpc_id.value
  public_subnet_ids  = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]
  ingress_alb_sg_id = data.aws_ssm_parameter.ingress_alb_sg_id.value

  common_tags = {
    project     = var.project
    environment = var.environment
    terraform   = true
  }
}