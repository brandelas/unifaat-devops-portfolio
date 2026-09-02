resource "aws_iam_policy" "s3_read" {
  name        = "${var.ra}-technova-s3-read"
  description = "Permite leitura de objetos S3 do projeto TechNova"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject"
        ]

        Resource = "arn:aws:s3:::technova-*/*"
      },
      {
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = "arn:aws:s3:::technova-*"
      }
    ]
  })
}

resource "aws_iam_policy" "ec2_s3" {
  name        = "${var.ra}-technova-ec2-s3"
  description = "Permite operacoes controladas de EC2 e S3 para Platform Engineering"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "ec2:DescribeInstances"
        ]

        Resource = "*"
      },
      {
        Effect = "Allow"

        Action = [
          "ec2:StartInstances",
          "ec2:StopInstances"
        ]

        Resource = "*"

        Condition = {
          StringEquals = {
            "ec2:ResourceTag/Project" = "TechNova"
          }
        }
      },
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]

        Resource = "arn:aws:s3:::technova-*/*"
      },
      {
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = "arn:aws:s3:::technova-*"
      }
    ]
  })
}

resource "aws_iam_policy" "deny_destructive" {
  name        = "${var.ra}-technova-deny-destructive"
  description = "Bloqueia operacoes destrutivas para protecao dos recursos TechNova"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Deny"

        Action = [
          "s3:DeleteBucket",
          "s3:DeleteObject",
          "ec2:TerminateInstances",
          "ec2:Delete*",
          "iam:Delete*"
        ]

        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "developers_s3_read" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.s3_read.arn
}

resource "aws_iam_group_policy_attachment" "developers_deny" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.deny_destructive.arn
}

resource "aws_iam_group_policy_attachment" "platform_ec2_s3" {
  group      = aws_iam_group.platform_eng.name
  policy_arn = aws_iam_policy.ec2_s3.arn
}

resource "aws_iam_group_policy_attachment" "platform_deny" {
  group      = aws_iam_group.platform_eng.name
  policy_arn = aws_iam_policy.deny_destructive.arn
}