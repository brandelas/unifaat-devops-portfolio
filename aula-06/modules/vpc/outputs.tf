output "vpc_id" {
  description = "ID da VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "IDs das subnets públicas"
  value = [
    for key, subnet in aws_subnet.this :
    subnet.id
    if var.subnets[key].type == "public"
  ]
}

output "private_subnet_ids" {
  description = "IDs das subnets privadas"
  value = [
    for key, subnet in aws_subnet.this :
    subnet.id
    if var.subnets[key].type == "private"
  ]
}