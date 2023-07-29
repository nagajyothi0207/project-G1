variable "vpc_id" {
  description = "Defalt VPC ID"
  type        = string
}

variable "myip" {
  description = "The public IP of your trusted network to access the Bastion Server"
  default     = "220.255.16.111/32"
}

module "network_stack" {
  source               = "./Network_Stack"
  default_vpc_id       = var.vpc_id
  my_public_ip_address = var.myip
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
  default_vpc_id              = var.vpc_id
  key_name                    = "CKA-cluster-key"
  minimum_size_for_asg        = "1"
  max_size_for_asg            = "1"
  desired_size_for_asg        = "1"
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