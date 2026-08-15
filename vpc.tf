

#****************************
#           VPC
#****************************

resource "aws_vpc" "streaming" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    name = "Streaming"
  }
}

resource "aws_subnet" "streaming_1a" {
  vpc_id                  = aws_vpc.streaming.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Streaming_1a"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.streaming.id

  tags = {
    Name = "Streaming-igw"
  }
}

resource "aws_route_table" "puplic_rt" {
  vpc_id = aws_vpc.streaming.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Streaming-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.streaming_1a.id
  route_table_id = aws_route_table.puplic_rt.id
}


#****************************
#   Security Group Section
#****************************


resource "aws_security_group" "allow_udp" {
  name        = "allow_udp"
  description = "Allow UDP traffic inbound"
  vpc_id      = aws_vpc.streaming.id

  tags = {
    Name = "allow_udp"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_srt_ports" {
  security_group_id = aws_security_group.allow_udp.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 40159
  ip_protocol       = "udp"
  to_port           = 40560
}


resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.allow_udp.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_udp.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


#****************************
#   Key Pair Section
#****************************

resource "aws_key_pair" "video_relay" {
  key_name   = "video-relay"
  public_key = tls_private_key.key_pair.public_key_openssh
}

resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content  = tls_private_key.key_pair.private_key_pem
  filename = "video-relay"
}