provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

# To create IAM user-1
resource "aws_iam_user" "example_user1" {
  name = "node_user1"
}

# To create Login profile for user-1
resource "aws_iam_user_login_profile" "example_user1_login_profile" {
  user                    = aws_iam_user.example_user1.name
  password_reset_required = true
  password_length         = 12 # Set your desired password length
}

# To create IAM user ChangePasswordPolicy for user-1
resource "aws_iam_user_policy" "example_user_policy" {
  name   = "ChangePasswordPolicy"
  user   = aws_iam_user.example_user1.name
  policy = <<-EOF
{
  "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:ChangePassword"
            ],
            "Resource": [
                "arn:aws:iam::*:user/node_user1"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:GetAccountPasswordPolicy"
            ],
            "Resource": "*"
        }
    ]
}
  EOF
}

# To get the AMI id
data "aws_caller_identity" "current" {}

# To create the KMS key
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
        },
        {
            "Sid": "Allow use of the key",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/node_user1"
                ]
            },
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow attachment of persistent resources",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/node_user1"
                ]
            },
            "Action": [
                "kms:CreateGrant",
                "kms:ListGrants",
                "kms:RevokeGrant"
            ],
            "Resource": "*",
            "Condition": {
                "Bool": {
                    "kms:GrantIsForAWSResource": "true"
                }
            }
        }
    ]
}
POLICY
}

# To create the alias for KMS
resource "aws_kms_alias" "my_kms_alias" {
  target_key_id = aws_kms_key.my_kms_key.key_id
  name          = "alias/${var.kms_alias}"
}
