# To create the Lambda function
resource "aws_lambda_function" "html_lambda" {
  filename         = "index.zip"
  function_name    = "MyLambdaFunction"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "index.handler"
  runtime          = "nodejs14.x"
  source_code_hash = data.archive_file.lambda_package.output_base64sha256
  layers           = [aws_lambda_layer_version.example_layer.arn]
  depends_on = [
    aws_iam_role_policy_attachment.lambda_policy_attachment,
    aws_cloudwatch_log_group.lambda_log_group,
  ]

  environment {
    variables = {
      KEY1 = "value1",
      KEY2 = "value2",
      SECRET_NAME = aws_secretsmanager_secret.example_secret.name
    }
  }
}

# Convert normal file to Zip file
data "archive_file" "lambda_package" {
  type        = "zip"
  source_file = "/home/ec2-user/index.js"
  output_path = "${path.module}/index.zip"
}

# Convert normal file to Zip file for layer
data "archive_file" "lambda_package1" {
  type        = "zip"
  source_file = "/home/ec2-user/index1.js"
  output_path = "${path.module}/index1.zip"
}

# To create lambda layer
resource "aws_lambda_layer_version" "example_layer" {
  layer_name  = "layer-1"
  description = "My Lambda layer"

  filename = data.archive_file.lambda_package1.output_path
  source_code_hash = data.archive_file.lambda_package1.output_base64sha256

  compatible_runtimes = ["nodejs14.x"] # Adjust to the runtime you are using
}

# To create the cloud watch to see logs
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/MyLambdaFunction" # Adjust the name to match your Lambda function's name
  retention_in_days = 14
}

# To create the lambda policy role for lambda
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
      },
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "secretsmanager.amazonaws.com"
        },
        "Action": [
		    "secretsmanager:GetResourcePolicy",
			  "secretsmanager:GetSecretValue",
			  "secretsmanager:DescribeSecret",
			  "secretsmanager:ListSecretVersionIds"
	    ],
        "Resource": "${aws_secretsmanager_secret.example_secret.arn}"
       }
    ],
  })
}

# To create cloud policy role for cloud watch
resource "aws_iam_policy" "lambda_policy" {
  name        = "MyLambdaPolicy" # Name for the policy
  description = "Policy for My Lambda Function"

  # Define the policy document with the necessary permissions
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"],
        Effect   = "Allow",
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# Attach a policy to the Lambda execution role if needed
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# To create the API gateway
resource "aws_api_gateway_rest_api" "my_api" {
  name        = "my-api"
  description = "My API Gateway"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# To create the API gateway resource
resource "aws_api_gateway_resource" "my_resource" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part   = "conversion"
}

# To create API gateway method
resource "aws_api_gateway_method" "my_method" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.my_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# To create the API gateway integration
resource "aws_api_gateway_integration" "my_integration" {
  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = aws_api_gateway_resource.my_resource.id
  http_method             = aws_api_gateway_method.my_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.html_lambda.invoke_arn
}

data "aws_caller_identity" "current" {}

# Attach the Lambda function's permission to be invoked by API Gateway
resource "aws_lambda_permission" "apigw_invoke_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.html_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.my_api.id}/*/${aws_api_gateway_method.my_method.http_method}${aws_api_gateway_resource.my_resource.path}"
}

# To create the API deployment
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id

  depends_on = [aws_api_gateway_method.my_method, aws_api_gateway_integration.my_integration]

}

# To create API gateway stage
resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  stage_name    = "dev"

}