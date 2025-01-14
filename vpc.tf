# VPC and Subnet for ECS
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "ecs_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "ecs-subnet"
  }
}
