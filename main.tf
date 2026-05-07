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

