# BUILD a VPC from Scratch

# Fetch latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name = "name"

    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# Fetch availablity AZs in current region
data "aws_availability_zones" "available" {
  state = "available"
}

# 1. VPC
resource "aws_vpc" "terraweek_vpc" {
  cidr_block = var.vpc_cidr
  tags = merge(
    local.common_tags,
    {
      Name        = "${local.name_prefix}-VPC"
      Environment = var.environment
    },
    var.extra_tags
  )
}

# 2. Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.terraweek_vpc.id
  map_public_ip_on_launch = true
  cidr_block              = var.subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      Name = "${local.name_prefix}-Subnet"
    }
  )
}

# 3. Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.terraweek_vpc.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-IGW"
    },
    var.extra_tags
  )
}

# 4. Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.terraweek_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      Name = "${local.name_prefix}-RT"
  })
}

# 5. Route Table Association
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# 6. Security Group
resource "aws_security_group" "terraweek_sg" {
  name        = "${local.name_prefix}-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.terraweek_vpc.id

  dynamic "ingress" {
    for_each = var.allowed_ports



    # SSH Access
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Outbound Traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name        = "${var.project_name}-SG"
      Environment = var.environment
    },
    var.extra_tags
  )
}

# 7. EC2 Instance
resource "aws_instance" "terraweek_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.environment == "prod" ? "t3.small" : "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.terraweek_sg.id]

  lifecycle {
    create_before_destroy = true
  }
  associate_public_ip_address = true
  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-Server"
    },
    var.extra_tags
  )
}

# S3 Bucket for Application Logs
resource "aws_s3_bucket" "app_logs" {
  bucket     = "${var.project_name}-app-logs-unique-12345"
  depends_on = [aws_instance.terraweek_server]

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      Name = "${local.name_prefix}-Logs"
  })
}


