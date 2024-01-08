output "key_arn" {
  value = aws_kms_key.my_kms_key.arn
}

output "key_id" {
  value = aws_kms_key.my_kms_key.key_id
}

output "iam_user_console_login_link" {
  value = "https://254669244016.signin.aws.amazon.com/console/"
}