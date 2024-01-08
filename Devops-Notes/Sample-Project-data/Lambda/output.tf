output "lambda_function_name" {
  value = aws_lambda_function.html_lambda.function_name
}

output "api_gateway_url" {
  value = aws_api_gateway_rest_api.my_api.invoke_url
}

output "secret_manager_secret_name" {
  value = aws_secretsmanager_secret.example_secret.name
}