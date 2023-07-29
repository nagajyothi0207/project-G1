resource "aws_subnet" "public_subnet" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = "172.31.${100+count.index}.0/27"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "Public_Subnet-${data.aws_availability_zones.available.names[count.index]}"
  }
}


resource "aws_network_acl" "public_subnet_nacl" {
  vpc_id = data.aws_vpc.default.id
  subnet_ids = aws_subnet.public_subnet[*].id
# For NATGW Access from VPC Cidr
ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = data.aws_vpc.default.cidr_block
    from_port  = 1024
    to_port    = 65535
  }

# Communication to ALB on Nginx Port
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_subnet.private_subnet[0].cidr_block
    from_port  = 80
    to_port    = 80
  }
egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = aws_subnet.private_subnet[1].cidr_block
    from_port  = 80
    to_port    = 80
  }
egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = aws_subnet.private_subnet[2].cidr_block
    from_port  = 80
    to_port    = 80
  }

# Optional for SSH Traffic to private Servers (Optioal - Only if Bastion Server deployment needed)

ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.my_public_ip_address
    from_port  = 22
    to_port    = 22
  }

# Internet Access to the ALB for Ngnix page
ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  egress {
    protocol   = "tcp"
    rule_no    = 500
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }


  # Internet out for NATGW (Optional - Only required if NATGW deployment is needed)
    egress {
    protocol   = "tcp"
    rule_no    = 1400
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
    ingress {
    protocol   = "tcp"
    rule_no    = 1400
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
  tags = {
    Name = "Public NACL"
  }
}

data "aws_internet_gateway" "default_igw" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = data.aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.default_igw.id
  }

  tags = {
    Name = "public_RT"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_subnet[0].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.public_subnet[1].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.public_subnet[2].id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_security_group" "Public_SG" {
  name        = "Public_SG_allow_http"
  description = "Allow http inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_public_ip_address]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.private_security_group.id]
  }

    egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Public_SG_allow_http"
  }
}

