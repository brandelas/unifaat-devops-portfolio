data "aws_iam_instance_profile" "lab" {
  count = var.use_academy_instance_profile ? 1 : 0
  name  = var.academy_instance_profile_name
}

# O Learner Lab bloqueia iam:CreateRole. Por isso o modo padrao reutiliza o
# profile fornecido pelo Academy. Fora dele, habilite create_dedicated_iam_role
# para criar uma role com o privilegio minimo exigido pelo TF.
resource "aws_iam_role" "api" {
  count = var.create_dedicated_iam_role ? 1 : 0
  name  = "technova-api-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = merge(local.common_tags, {
    Name = "technova-api-role"
  })
}

resource "aws_iam_role_policy_attachment" "api_s3_read_only" {
  count      = var.create_dedicated_iam_role ? 1 : 0
  role       = aws_iam_role.api[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "api" {
  count = var.create_dedicated_iam_role ? 1 : 0
  name  = "technova-api-instance-profile"
  role  = aws_iam_role.api[0].name

  tags = merge(local.common_tags, {
    Name = "technova-api-instance-profile"
  })
}
