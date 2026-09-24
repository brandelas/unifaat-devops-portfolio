output "developers_group_name" {
  description = "Nome do grupo de desenvolvedores"
  value       = aws_iam_group.developers.name
}

output "platform_eng_group_name" {
  description = "Nome do grupo de Platform Engineering"
  value       = aws_iam_group.platform_eng.name
}

output "users" {
  description = "Usuarios IAM criados"
  value = {
    juliana = aws_iam_user.juliana.name
    rafael  = aws_iam_user.rafael.name
    lucas   = aws_iam_user.lucas.name
  }
}

output "policy_arns" {
  description = "ARNs das policies customizadas"
  value = {
    s3_read          = aws_iam_policy.s3_read.arn
    ec2_s3           = aws_iam_policy.ec2_s3.arn
    deny_destructive = aws_iam_policy.deny_destructive.arn
  }
}

output "ec2_role_arn" {
  description = "ARN da IAM Role utilizada pela EC2"
  value       = aws_iam_role.ec2_role.arn
}

output "ec2_instance_profile_arn" {
  description = "ARN do Instance Profile da EC2"
  value       = aws_iam_instance_profile.ec2_profile.arn
}