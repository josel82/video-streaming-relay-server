resource "aws_instance" "video-stream-relay" {
  ami           = "ami-0ef0fafba270833fc"
  instance_type = "t2.small"
  security_groups = [ aws_security_group.allow_udp.name ]
  key_name = "video-relay"
  user_data = "${file("instance-init.sh")}"

  tags = {
    Name = "Video-stream-relay"
  }
}


#****************************
#   Security Group Section
#****************************


resource "aws_security_group" "allow_udp" {
  name        = "allow_udp"
  description = "Allow UDP traffic inbound"
  vpc_id      = var.vpc_id

  tags = {
    Name = "allow_udp"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_inbound_a" {
  security_group_id = aws_security_group.allow_udp.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 5000
  ip_protocol       = "udp"
  to_port           = 5000
}

resource "aws_vpc_security_group_ingress_rule" "allow_inbound_b" {
  security_group_id = aws_security_group.allow_udp.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 5022
  ip_protocol       = "udp"
  to_port           = 5022
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