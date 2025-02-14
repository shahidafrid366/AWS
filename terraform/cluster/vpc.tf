resource "aws_vpc" "Assignment_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Public subnets in different availability zones
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.Assignment_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_a"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.Assignment_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_b"
  }
}

resource "aws_subnet" "public_subnet_c" {
  vpc_id                  = aws_vpc.Assignment_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_c"
  }
}

# Private subnets in different availability zones
resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.Assignment_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private_subnet_a"
  }
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id            = aws_vpc.Assignment_vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private_subnet_b"
  }
}

resource "aws_subnet" "private_subnet_c" {
  vpc_id            = aws_vpc.Assignment_vpc.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "private_subnet_c"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "Assignment_igw" {
  vpc_id = aws_vpc.Assignment_vpc.id
}

# Public Route Table
resource "aws_route_table" "public_subnet_rt" {
  vpc_id = aws_vpc.Assignment_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Assignment_igw.id
  }
}

# Private Route Table
resource "aws_route_table" "private_subnet_rt" {
  vpc_id = aws_vpc.Assignment_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.Assignment_nat.id
  }
}

# Route table associations for public subnets
resource "aws_route_table_association" "public_subnet_rt_association_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_subnet_rt.id
}

resource "aws_route_table_association" "public_subnet_rt_association_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_subnet_rt.id
}

resource "aws_route_table_association" "public_subnet_rt_association_c" {
  subnet_id      = aws_subnet.public_subnet_c.id
  route_table_id = aws_route_table.public_subnet_rt.id
}

# Route table associations for private subnets
resource "aws_route_table_association" "private_subnet_rt_association_a" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_subnet_rt.id
}

resource "aws_route_table_association" "private_subnet_rt_association_b" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private_subnet_rt.id
}

resource "aws_route_table_association" "private_subnet_rt_association_c" {
  subnet_id      = aws_subnet.private_subnet_c.id
  route_table_id = aws_route_table.private_subnet_rt.id
}

# Elastic IP for NAT Gateway
resource "aws_eip" "Assignment_eip" {
  domain = "vpc"

  tags = {
    Name = "Assignment-eip"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "Assignment_nat" {
  allocation_id = aws_eip.Assignment_eip.id
  subnet_id     = aws_subnet.public_subnet_a.id
  depends_on     = [aws_eip.Assignment_eip]
  tags = {
    Name = "Assignment-nat-gateway"
  }
}

# Public NACL
resource "aws_network_acl" "public_nacl" {
  vpc_id = aws_vpc.Assignment_vpc.id

  ingress {
    rule_no    = 100
    protocol   = "tcp"
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    rule_no    = 110
    protocol   = "-1"
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    rule_no    = 100
    protocol   = "-1" 
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "public_nacl"
  }
}


# Associate NACLs with subnets
resource "aws_network_acl_association" "public_subnet_a_association" {
  subnet_id        = aws_subnet.public_subnet_a.id
  network_acl_id   = aws_network_acl.public_nacl.id
}

resource "aws_network_acl_association" "public_subnet_b_association" {
  subnet_id        = aws_subnet.public_subnet_b.id
  network_acl_id   = aws_network_acl.public_nacl.id
}

resource "aws_network_acl_association" "public_subnet_c_association" {
  subnet_id        = aws_subnet.public_subnet_c.id
  network_acl_id   = aws_network_acl.public_nacl.id
}

