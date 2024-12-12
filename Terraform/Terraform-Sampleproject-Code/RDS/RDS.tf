# Create an First EC2 instance
resource "aws_instance" "example_instance" {
  ami                         = var.ami           # Change to your desired AMI ID
  instance_type               = var.instance_type # Change to your desired instance type
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true         # Enable a public IP
  key_name                    = var.key_name # Change to your key pair name
  availability_zone           = var.availability_zone
  user_data                   = filebase64("/home/ec2-user/file.sh")
  vpc_security_group_ids      = [aws_security_group.example_security_group.id]

  tags = {
    Name = "Ec-1"
  }
}

# To create db subnet group for RDS
resource "aws_db_subnet_group" "mydb_subnet_group" {
  name        = "mydb-subnet-group"
  description = "My RDS Subnet Group"
  subnet_ids  = [aws_subnet.public.id, aws_subnet.private.id] # Replace with your subnet IDs
}

# To create the RDS
resource "aws_db_instance" "mydb" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.medium"
  identifier           = "varmadb"   # Specify your RDS instance name
  username             = "admin"     # Master username
  password             = "vamsi3003" # Replace with your actual password  or master password
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true # Set to true to skip creating a final snapshot

  vpc_security_group_ids = [aws_security_group.example_security_group.id]
  db_subnet_group_name   = aws_db_subnet_group.mydb_subnet_group.name

  # Enable storage encryption and specify KMS key
  storage_encrypted = true
  kms_key_id        = aws_kms_key.my_kms_key.arn # Use the correct ARN for your KMS key
  db_name           = "bulepalrds"               # Set your desired database name
}

# To create the secret managner
resource "aws_secretsmanager_secret" "example_secret" {
  name = "db-sham"
}

# To store the RDS data  credentials
resource "aws_secretsmanager_secret_version" "example_secret_version" {
  secret_id = aws_secretsmanager_secret.example_secret.id
  secret_string = jsonencode({
    username = "dbuser",     # RDS username
    password = "dbpassword", # RDS password
  })
}


