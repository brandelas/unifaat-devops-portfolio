resource "aws_key_pair" "technova" {
  key_name   = var.key_pair_name
  public_key = file(var.public_key_path)

  tags = merge(local.common_tags, {
    Name = "technova-key-pair"
  })
}
