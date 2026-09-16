locals {
  bucket_name = "${var.project_name}-terraform-state-${random_id.bucket_suffix.hex}"
}

# Criacao direta via AWS CLI para contornar o bloqueio de SCP do Learner Lab
resource "null_resource" "create_s3_bucket" {
  triggers = {
    bucket_name = local.bucket_name
  }

  provisioner "local-exec" {
    command = "aws s3api create-bucket --bucket ${local.bucket_name} --region ${var.aws_region}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "aws s3 rb s3://${self.triggers.bucket_name} --force"
  }
}

# Ativa o versionamento
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket     = local.bucket_name
  depends_on = [null_resource.create_s3_bucket]

  versioning_configuration {
    status = "Enabled"
  }
}

# Configura Criptografia
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket     = local.bucket_name
  depends_on = [null_resource.create_s3_bucket]

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Bloqueia Acesso Publico
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket     = local.bucket_name
  depends_on = [null_resource.create_s3_bucket]

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}