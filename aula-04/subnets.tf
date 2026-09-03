resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.technova.id
  cidr_block              = var.public_subnet_cidrs[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "technova-public-subnet-1"
  })
}

resource "aws_subnet" "private_1" {
  vpc_id                  = aws_vpc.technova.id
  cidr_block              = var.private_subnet_cidrs[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, {
    Name = "technova-private-subnet-1"
  })
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.technova.id
  cidr_block              = var.public_subnet_cidrs[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "technova-public-subnet-2"
  })
}

resource "aws_subnet" "private_2" {
  vpc_id                  = aws_vpc.technova.id
  cidr_block              = var.private_subnet_cidrs[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, {
    Name = "technova-private-subnet-2"
  })
}
