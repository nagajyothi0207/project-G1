output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}


output "public_subnet_nacl" {
  value = aws_subnet.public_subnet[*].id
}

output "Public_SG" {
  value = aws_security_group.Public_SG[*].id
}
output "Private_SG" {
  value = aws_security_group.private_security_group[*].id
}
