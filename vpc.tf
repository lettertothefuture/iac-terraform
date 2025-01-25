# Create a VPC
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/21"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

# Create a subnet
resource "aws_subnet" "ecs_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "sa-east-1a"
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "main-vpc"
  }

}

resource "aws_route_table" "routetable" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }

}

resource "aws_route_table_association" "RTA" {
  subnet_id      = aws_subnet.ecs_subnet.id
  route_table_id = aws_route_table.routetable.id

}




# Create a security group for the ECS cluster
resource "aws_security_group" "example" {
  name        = "ecs-cluster-sg"
  description = "Security group for ECS cluster"
  vpc_id      = aws_vpc.main_vpc.id

  # Allow inbound traffic on port 32768 (ECS container agent)
  ingress {
    from_port   = 32768
    to_port     = 32768
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound traffic to the Docker Hub registry
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["185.199.108.0/22", "35.156.79.144/32"]
  }
}