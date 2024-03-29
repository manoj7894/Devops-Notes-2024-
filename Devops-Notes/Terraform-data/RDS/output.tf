output "key_arn" {
  value = aws_kms_key.my_kms_key.arn
}

output "key_id" {
  value = aws_kms_key.my_kms_key.key_id
}

output "example" {
  value = jsondecode(aws_secretsmanager_secret_version.example_secret_version.secret_string)["username"]
}