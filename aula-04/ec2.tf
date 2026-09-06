data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name = "name"
    # Restringe a busca a Amazon Linux 2023 padrao, evitando variantes como ECS Optimized.
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

resource "aws_instance" "api" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_1.id
  vpc_security_group_ids = [aws_security_group.api.id]
  iam_instance_profile   = local.instance_profile_name
  key_name               = aws_key_pair.technova.key_name
  user_data = templatefile("${path.module}/user-data.sh.tftpl", {
    technova_api_repo_url = var.technova_api_repo_url
  })
  user_data_replace_on_change = true

  root_block_device {
    # A AMI Amazon Linux 2023 selecionada possui snapshot raiz de 30 GB;
    # a AWS nao permite criar um volume menor que o snapshot de origem.
    volume_size = 30
    volume_type = "gp2"
    tags = merge(local.common_tags, {
      Name = "technova-api-root-volume"
    })
  }

  tags = merge(local.common_tags, {
    Name = "technova-api-ec2"
  })
}
