data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "api" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_1.id
  vpc_security_group_ids = [aws_security_group.api.id]
  iam_instance_profile = data.aws_iam_instance_profile.lab.name
  key_name               = aws_key_pair.technova.key_name
  user_data = templatefile("${path.module}/user-data.sh.tftpl", {
    technova_api_repo_url = var.technova_api_repo_url
  })

  tags = merge(local.common_tags, {
    Name = "technova-api-ec2"
  })
}
