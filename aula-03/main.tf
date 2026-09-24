locals {
  common_tags = {
    Project    = var.project_name
    ManagedBy  = "Terraform"
    Aluno      = var.aluno
    RA         = var.ra
    Disciplina = var.disciplina
    Aula       = var.aula
  }
}

resource "aws_iam_group" "developers" {
  name = "${var.ra}-technova-developers"
}

resource "aws_iam_group" "platform_eng" {
  name = "${var.ra}-technova-platform-eng"
}

resource "aws_iam_user" "juliana" {
  name = "${var.ra}-juliana-dev"

  tags = local.common_tags
}

resource "aws_iam_user" "rafael" {
  name = "${var.ra}-rafael-platform"

  tags = local.common_tags
}

resource "aws_iam_user" "lucas" {
  name = "${var.ra}-lucas-intern"

  tags = local.common_tags
}

resource "aws_iam_user_group_membership" "juliana" {
  user   = aws_iam_user.juliana.name
  groups = [aws_iam_group.developers.name]
}

resource "aws_iam_user_group_membership" "rafael" {
  user = aws_iam_user.rafael.name

  groups = [
    aws_iam_group.developers.name,
    aws_iam_group.platform_eng.name
  ]
}

resource "aws_iam_user_group_membership" "lucas" {
  user   = aws_iam_user.lucas.name
  groups = [aws_iam_group.developers.name]
}