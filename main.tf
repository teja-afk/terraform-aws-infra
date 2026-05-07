# BUILD a VPC from Scratch

# 1. VPC
resource aws_vpc terraweek_vpc {
	cidr_block = "10.0.0.0/16"
	tags = {
		Name = "TerraWeek-VPC"
	}
}

# 2. Public Subnet
resource aws_subnet public_subnet {
	vpc_id = aws_vpc.terraweek_vpc.id
	map_public_ip_on_launch = true
	cidr_block="10.0.1.0/24"
	tags = {
		Name = "TerraWeek-Public-Subnet"
	}
}

# 3. Internet Gateway
resource aws_internet_gateway igw {
	vpc_id = aws_vpc.terraweek_vpc.id
	
	tags = {
		Name = "TerraWeek-IGW"
	}
}

# 4. Route Table
resource aws_route_table public_rt {
	vpc_id = aws_vpc.terraweek_vpc.id
	
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.igw.id
	}

	tags = {
		Name = "TerraWeek-Public-RT"
	}
}

# 5. Route Table Association
resource aws_route_table_association public_assoc {
	subnet_id = aws_subnet.public_subnet.id
	route_table_id = aws_route_table.public_rt.id
}

# 6. Security Group
resource aws_security_group terraweek_sg {
	name = "terraweek-sg"
	description = "Allow SSH and HTTP"
	vpc_id = aws_vpc.terraweek_vpc.id

	# SSH Access
	ingress {
		description= "SSH"
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	
	# HTTP Acess
	ingress {
		description = "HTTP"
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	# Outbound Traffic
	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
	
	tags = {
		Name = "TerraWeek-SG"
	}
}

# 7. EC2 Instance
resource aws_instance terraweek_server {
	ami = "ami-06c77cb49ac92a541"
	instance_type = "t2.micro"
	subnet_id = aws_subnet.public_subnet.id
	vpc_security_group_ids = [aws_security_group.terraweek_sg.id]

	lifecycle {
    		create_before_destroy = true
  	}
	associate_public_ip_address = true
	tags = {
		Name = "TerraWeek-Server"
	}
}

# S3 Bucket for Application Logs
resource aws_s3_bucket app_logs {
	bucket = "terraweek-app-logs-unique-12345"
	depends_on = [aws_instance.terraweek_server]
	
	tags = {
		Name = "TerraWeek-App-Logs"
	}
}


