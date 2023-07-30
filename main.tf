variable "myip" {
  description = "The public IP of your trusted network to access the Bastion Server"
  default     = ""
}
variable "vpc_cidr" {
  description = "cidr block for VPC creation, e.g 172.31.0.0/16"
  default     = ""
}

module "network_stack" {
  source               = "./Network_Stack"
  vpc_cidr_block       = var.vpc_cidr
  my_public_ip_address = var.myip # Your public IP address to allow SSH Access to the Bastion Host
}

output "vpc_id" {
  value = module.network_stack.vpc_id
}
output "public_subnets" {
  value = module.network_stack.public_subnets
}
output "private_subnets" {
  value = module.network_stack.private_subnets
}
output "private_subnet_ids" {
  value = module.network_stack.private_subnet_ids
}
output "public_subnet_ids" {
  value = module.network_stack.public_subnet_ids
}

output "public_subnet_ids_1" {
  value = module.network_stack.public_subnet_ids[0]
}


module "application_stack" {
  source                      = "./Application_Stack"
  nginx_app_setup             = true
  bastion_server_provisioning = false # If Bastion/Jump server required on Public Subnet, then make this 'true'
  public_subnet_ids           = module.network_stack.public_subnet_ids
  private_subnet_ids          = module.network_stack.private_subnet_ids
  bastion_host_subnet_id      = module.network_stack.public_subnet_ids[0]
  public_security_group_ids   = module.network_stack.Public_SG
  private_security_group_ids  = module.network_stack.Private_SG
  default_vpc_id              = module.network_stack.vpc_id
  key_name                    = "CKA-cluster-key"
  minimum_size_for_asg        = "3"
  max_size_for_asg            = "3"
  desired_size_for_asg        = "3"
}

output "alb_dns_name" {
  value = "http://${module.application_stack.alb_dns_name}"
}


output "ec2instance_public_ip" {
  value = module.application_stack.ec2instance_public_ip
}

output "s3bucket_domain_name" {
  value = module.application_stack.s3bucket_domain_name
}

output "autoscaling_group_name" {
  value = module.application_stack.autoscaling_group_name
}

output "iam_policy" {
  value = module.application_stack.iam_policy
}
