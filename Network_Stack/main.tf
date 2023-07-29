
# subnet creation
resource "aws_vpc_endpoint" "endpoints" {
#  count   = var.create_ssm_endpoints ? 1 : 0
  vpc_id            = data.aws_vpc.default.id
  subnet_ids        = [aws_subnet.private_subnet[0].id]
  for_each          = local.endpoints
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  service_name      = "com.amazonaws.${local.region}.${each.value.name}"
  # Add a security group to the VPC endpoint
  security_group_ids = [aws_security_group.private_security_group.id]
}