resource "aws_subnet" "private_subnet" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = "172.31.${90+count.index}.0/27"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "Private_Subnet-${data.aws_availability_zones.available.names[count.index]}"
  }
}


resource "aws_network_acl" "private_subnet_nacl" {
  vpc_id = data.aws_vpc.default.id
  subnet_ids = aws_subnet.private_subnet[*].id

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_subnet.public_subnet[0].cidr_block
    from_port  = 80
    to_port    = 80
  }

    ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = aws_subnet.public_subnet[1].cidr_block
    from_port  = 80
    to_port    = 80
  }
    ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = aws_subnet.private_subnet[2].cidr_block
    from_port  = 80
    to_port    = 80
  }

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = data.aws_vpc.default.cidr_block
    from_port  = 1024
    to_port    = 65535
  }


  ingress {
    protocol   = "tcp"
    rule_no    = 400
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
  egress {
    protocol   = "tcp"
    rule_no    = 400
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }


  ingress {
    protocol   = "tcp"
    rule_no    = 1000
    action     = "allow"
    cidr_block = aws_subnet.public_subnet[0].cidr_block
    from_port  = 22
    to_port    = 22
  }
  egress {
    protocol   = "tcp"
    rule_no    = 500
    action     = "allow"
    cidr_block = aws_subnet.public_subnet[0].cidr_block
    from_port  = 1024
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 1100
    action     = "allow"
    cidr_block = data.aws_vpc.default.cidr_block
    from_port  = 443
    to_port    = 443
  }
  egress {
    protocol   = "tcp"
    rule_no    = 1100
    action     = "allow"
    cidr_block = data.aws_vpc.default.cidr_block
    from_port  = 443
    to_port    = 443
  }

  tags = {
    Name = "Private_NACL"
  }
}

resource "aws_eip" "nat_gateway" {
  domain = "vpc"
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.public_subnet[0].id
  connectivity_type = "public"
  tags = {
    Name = "NATGW"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id          = data.aws_vpc.default.id
  service_name    = "com.amazonaws.${data.aws_region.current.name}.s3"
  route_table_ids = ["${aws_route_table.private_rt.id}"]

  tags = {
    Name = "my-s3-endpoint"
  }
}


resource "aws_route_table" "private_rt" {
  vpc_id = data.aws_vpc.default.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.natgw.id
  }
  tags = {
    Name = "Private_RT"
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_subnet[0].id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_subnet[1].id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_c" {
  subnet_id      = aws_subnet.private_subnet[2].id
  route_table_id = aws_route_table.private_rt.id
}


resource "aws_security_group" "private_security_group" {
  name        = "Private_SG_allow_local"
  description = "to allow traffic from private ips"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.public_subnet[0].cidr_block]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.public_subnet[0].cidr_block, aws_subnet.public_subnet[1].cidr_block, aws_subnet.public_subnet[2].cidr_block]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }
    egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Private SG"
  }
}
