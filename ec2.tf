

resource "aws_instance" "video-stream-relay" {
  ami                    = "ami-0ef0fafba270833fc"
  instance_type          = "t3.small"
  subnet_id              = aws_subnet.streaming_1a.id
  vpc_security_group_ids = [aws_security_group.allow_udp.id]
  key_name               = "video-relay"

  tags = {
    Name = "Video-stream-relay"
  }
}

output "instance_ip" {
  value = aws_instance.video-stream-relay.public_ip
}

output "instance_dns" {
  value = aws_instance.video-stream-relay.public_dns
}

