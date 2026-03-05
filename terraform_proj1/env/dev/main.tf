module "vpc" {
  source = "../../modules/vpc"

  cidr_block       = var.vpc_cidr
  public_subnet    = var.public_subnet
}

module "ec2" {
  source = "../../modules/ec2"

  subnet_id     = module.vpc.public_subnet_id
  instance_type = var.instance_type
  ami           = var.ami
}