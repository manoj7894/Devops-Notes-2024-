# How to create Private ECR
# Providers
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

# How to create the Private ECR
resource "aws_ecr_repository" "demo-repository" {
  name                 = "demo-repo"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# To attach the policy to above ECR
resource "aws_ecr_repository_policy" "demo-repo-policy" {
  repository = aws_ecr_repository.demo-repository.name
  policy = jsonencode({
    Version = "2008-10-17",
    Statement = [
      {
        Sid       = "adds full ecr access to the demo repository",
        Effect    = "Allow",
        Principal = "*",
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetLifecyclePolicy",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ecr:DescribeRepositories",
          "ecr:GetRepositoryPolicy",
          "ecr:ListImages",
          "ecr:DeleteRepository",
          "ecr:BatchDeleteImage",
          "ecr:SetRepositoryPolicy",
          "ecr:DeleteRepositoryPolicy"
        ]
      }
    ]
  })
}



# How to create Private ECR with KMS
# Providers
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Create an ECR Repository with KMS Encryption
resource "aws_ecr_repository" "demo-repository" {
  name = "my-docker-repo"
  encryption_configuration {
    encryption_type = "KMS"
    kms_key          = aws_kms_key.my_kms_key.arn
  }
  image_scanning_configuration {
    scan_on_push = true
  }
}

# To attach the policy to above ECR
resource "aws_ecr_repository_policy" "demo-repo-policy" {
  repository = aws_ecr_repository.demo-repository.name
  policy = jsonencode({
    Version = "2008-10-17",
    Statement = [
      {
        Sid       = "adds full ecr access to the demo repository",
        Effect    = "Allow",
        Principal = "*",
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetLifecyclePolicy",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ecr:DescribeRepositories",
          "ecr:GetRepositoryPolicy",
          "ecr:ListImages",
          "ecr:DeleteRepository",
          "ecr:BatchDeleteImage",
          "ecr:SetRepositoryPolicy",
          "ecr:DeleteRepositoryPolicy"
        ]
      }
    ]
  })
}

# To get the AMI
data "aws_caller_identity" "current" {}

# To create KMS key without adding any user
resource "aws_kms_key" "my_kms_key" {
  description              = "My KMS Keys for Data Encryption"
  customer_master_key_spec = var.key_spec         #SYMMETRIC_DEFAULT
  is_enabled               = var.enabled          # true
  enable_key_rotation      = var.rotation_enabled # true
  deletion_window_in_days  = 7

  tags = {
    Name = "my_kms_key"
  }

  policy = <<POLICY
{
    "Id": "key-consolepolicy-3",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        }
    ]
}
POLICY
}

# To create alias for KMS
resource "aws_kms_alias" "my_kms_alias" {
  target_key_id = aws_kms_key.my_kms_key.key_id
  name          = "alias/${var.kms_alias}"
}






# How to push the Docker image into Private ECR

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Define a null_resource to trigger local-exec provisioners
resource "null_resource" "build_and_push" {
  triggers = {
    # Trigger the provisioners whenever the build script changes
   # script_version = filebase64("/home/ec2-user/build.sh")  #in linux
     script_version = filebase64("./build.sh")     # in visual sudio code
  }

  # Use local-exec provisioners to build and push the Docker image
  provisioner "local-exec" {
    command = "docker build -t ${var.IMAGE_NAME}:latest ."
  }

  # To login the docker hub
  provisioner "local-exec" {
    command = "aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin ${aws_ecr_repository.demo-repository.repository_url}"
    # Note: Providing the password directly in the command might not be secure.
    # Consider using other secure methods for credentials.
  }

  # Tag the docker image
  provisioner "local-exec" {
    command = "docker tag ${var.IMAGE_NAME}:latest ${aws_ecr_repository.demo-repository.repository_url}:latest"
  }

  # To push image into docker hub
  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.demo-repository.repository_url}:latest"
  }
}

# How to create the Private ECR
resource "aws_ecr_repository" "demo-repository" {
  name                 = "demo-repo"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# To attach the policy to above ECR
resource "aws_ecr_repository_policy" "demo-repo-policy" {
  repository = aws_ecr_repository.demo-repository.name
  policy = jsonencode({
    Version = "2008-10-17",
    Statement = [
      {
        Sid       = "adds full ecr access to the demo repository",
        Effect    = "Allow",
        Principal = "*",
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetLifecyclePolicy",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ecr:DescribeRepositories",
          "ecr:GetRepositoryPolicy",
          "ecr:ListImages",
          "ecr:DeleteRepository",
          "ecr:BatchDeleteImage",
          "ecr:SetRepositoryPolicy",
          "ecr:DeleteRepositoryPolicy"
        ]
      }
    ]
  })
}



# How to push the Docker image into Private ECR along with kms

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Define a null_resource to trigger local-exec provisioners
resource "null_resource" "build_and_push" {
  triggers = {
    # Trigger the provisioners whenever the build script changes
   # script_version = filebase64("/home/ec2-user/build.sh")  #in linux
     script_version = filebase64("./build.sh")     # in visual sudio code
  }

  # Use local-exec provisioners to build and push the Docker image
  provisioner "local-exec" {
    command = "docker build -t ${var.IMAGE_NAME}:latest ."
  }

  # To login the docker hub
  provisioner "local-exec" {
    command = "aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin ${aws_ecr_repository.demo-repository.repository_url}"
    # Note: Providing the password directly in the command might not be secure.
    # Consider using other secure methods for credentials.
  }

  # Tag the docker image
  provisioner "local-exec" {
    command = "docker tag ${var.IMAGE_NAME}:latest ${aws_ecr_repository.demo-repository.repository_url}:latest"
  }

  # To push image into docker hub
  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.demo-repository.repository_url}:latest"
  }
}

# Create an ECR Repository with KMS Encryption
resource "aws_ecr_repository" "demo-repository" {
  name = "my-docker-repo"
  encryption_configuration {
    encryption_type = "KMS"
    kms_key          = aws_kms_key.my_kms_key.arn
  }
  image_scanning_configuration {
    scan_on_push = true
  }
}

# To attach the policy to above ECR
resource "aws_ecr_repository_policy" "demo-repo-policy" {
  repository = aws_ecr_repository.demo-repository.name
  policy = jsonencode({
    Version = "2008-10-17",
    Statement = [
      {
        Sid       = "adds full ecr access to the demo repository",
        Effect    = "Allow",
        Principal = "*",
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetLifecyclePolicy",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ecr:DescribeRepositories",
          "ecr:GetRepositoryPolicy",
          "ecr:ListImages",
          "ecr:DeleteRepository",
          "ecr:BatchDeleteImage",
          "ecr:SetRepositoryPolicy",
          "ecr:DeleteRepositoryPolicy"
        ]
      }
    ]
  })
}

# To get the AMI
data "aws_caller_identity" "current" {}

# To create KMS key without adding any user
resource "aws_kms_key" "my_kms_key" {
  description              = "My KMS Keys for Data Encryption"
  customer_master_key_spec = var.key_spec         #SYMMETRIC_DEFAULT
  is_enabled               = var.enabled          # true
  enable_key_rotation      = var.rotation_enabled # true
  deletion_window_in_days  = 7

  tags = {
    Name = "my_kms_key"
  }

  policy = <<POLICY
{
    "Id": "key-consolepolicy-3",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        }
    ]
}
POLICY
}

# To create alias for KMS
resource "aws_kms_alias" "my_kms_alias" {
  target_key_id = aws_kms_key.my_kms_key.key_id
  name          = "alias/${var.kms_alias}"
}











# Public repo is not working
resource "aws_ecrpublic_repository" "example" {
  repository_name = "example1"
}

data "aws_iam_policy_document" "example" {
  statement {
    sid    = "new policy"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy",
    ]
  }
}
resource "aws_ecrpublic_repository_policy" "example" {
  repository_name = aws_ecrpublic_repository.example.repository_name
  policy          = data.aws_iam_policy_document.example.json
}