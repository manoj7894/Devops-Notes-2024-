provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

# To create the secret managner
resource "aws_secretsmanager_secret" "example_secret" {
  name = "db-sham"
}

resource "aws_secretsmanager_secret_version" "example_secret_version" {
  secret_id = aws_secretsmanager_secret.example_secret.id
  secret_string = jsonencode({
    username = "dbuser",     # RDS username
    password = "dbpassword", # RDS password
  })
}

