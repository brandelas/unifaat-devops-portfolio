data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
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

data "aws_iam_instance_profile" "lab" {
  count = var.use_academy_instance_profile ? 1 : 0
  name  = var.academy_instance_profile_name
}

resource "aws_instance" "api" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_1.id
  vpc_security_group_ids = [aws_security_group.api.id]

  iam_instance_profile = data.aws_iam_instance_profile.lab[0].name
  key_name             = var.key_pair_name

  user_data = templatefile("${path.module}/user-data.sh.tftpl", {})

  tags = {
    Name = "${var.project_name}-api"
  }
}