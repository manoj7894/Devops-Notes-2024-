# To create node users KMS keys along with root users
# To create provider
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

# To create IAM user-1
resource "aws_iam_user" "example_user1" {
  name = "node_user1"
}

# To create IAM user-2
resource "aws_iam_user" "example_user2" {
  name = "node_user2"
}

# To create Login profile for user-1
resource "aws_iam_user_login_profile" "example_user1_login_profile" {
  user                    = aws_iam_user.example_user1.name
  password_reset_required = true
  password_length         = 12 # Set your desired password length
}

# To create Login profile for user-2
resource "aws_iam_user_login_profile" "example_user2_login_profile" {
  user                    = aws_iam_user.example_user2.name
  password_reset_required = true
  password_length         = 12 # Set your desired password length
}

# Attach IAM User Policy for Full S3 Access to user-1
resource "aws_iam_user_policy" "s3_full_access_policy1" {
  name = "s3_full_access_policy"
  user = aws_iam_user.example_user1.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
EOF
}

# To create IAM user ChangePasswordPolicy for user-1
resource "aws_iam_user_policy" "example_user_policy" {
  name       = "ChangePasswordPolicy"
  user       = aws_iam_user.example_user1.name
  policy     = <<-EOF
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

# Attach IAM User Policy for Full S3 Access to user-2
resource "aws_iam_user_policy" "s3_full_access_policy2" {
  name = "s3_full_access_policy"
  user = aws_iam_user.example_user2.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
EOF
}

# To create IAM user ChangePasswordPolicy for user-2
resource "aws_iam_user_policy" "example_user_policy1" {
  name       = "ChangePasswordPolicy"
  user       = aws_iam_user.example_user2.name
  policy     = <<-EOF
{
  "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:ChangePassword"
            ],
            "Resource": [
                "arn:aws:iam::*:user/node_user2"
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

# To get the AMI
data "aws_caller_identity" "current" {}

# To create KMS key
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
                "kms:Encrypt"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow use of the key by node_user2",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/node_user2"
                ]
            },
            "Action": [
                "kms:Decrypt"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow attachment of persistent resources",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/node_user1",
                    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/node_user2"
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

# To create alias for KMS
resource "aws_kms_alias" "my_kms_alias" {
  target_key_id = aws_kms_key.my_kms_key.key_id
  name          = "alias/${var.kms_alias}"
}





# To create node users KMS keys along with admin users
# To create provider
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

# To create admin user
resource "aws_iam_user" "example_user" {
  name = "admin_user"
}

# To create IAM user-1
resource "aws_iam_user" "example_user1" {
  name = "node_user1"
}

# To create IAM user-2
resource "aws_iam_user" "example_user2" {
  name = "node_user2"
}


# Create IAM User Login Profile with Password for admin user
resource "aws_iam_user_login_profile" "example_user_login_profile" {
  user                    = aws_iam_user.example_user.name
  password_reset_required = false
  password_length         = 12 # Set your desired password length
}

# Create IAM User Login Profile with Password for user-1
resource "aws_iam_user_login_profile" "example_user1_login_profile" {
  user                    = aws_iam_user.example_user1.name
  password_reset_required = false
  password_length         = 12 # Set your desired password length
}

# Create IAM User Login Profile with Password for user-2
resource "aws_iam_user_login_profile" "example_user2_login_profile" {
  user                    = aws_iam_user.example_user2.name
  password_reset_required = false
  password_length         = 12 # Set your desired password length
}


# Attach IAM User Policy for Full S3 Access to admin user
resource "aws_iam_user_policy" "s3_full_access_policy" {
  name = "s3_full_access_policy"
  user = aws_iam_user.example_user.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
EOF
}

# To create IAM user ChangePasswordPolicy for admin user
resource "aws_iam_user_policy" "example_user_policy" {
  name       = "ChangePasswordPolicy"
  user       = aws_iam_user.example_user.name
  policy     = <<-EOF
{
  "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:ChangePassword"
            ],
            "Resource": [
                "arn:aws:iam::*:user/admin_user"
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

# To attach the administration full acces to admin user
resource "aws_iam_user_policy_attachment" "admin_policy_attachment" {
  user       = aws_iam_user.example_user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Attach IAM User Policy for Full S3 Access to user-1
resource "aws_iam_user_policy" "s3_full_access_policy1" {
  name = "s3_full_access_policy"
  user = aws_iam_user.example_user1.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
EOF
}

# To create IAM user ChangePasswordPolicy for user-1
resource "aws_iam_user_policy" "example_user_policy1" {
  name       = "ChangePasswordPolicy"
  user       = aws_iam_user.example_user.name
  policy     = <<-EOF
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

# Attach IAM User Policy for Full S3 Access to user-2
resource "aws_iam_user_policy" "s3_full_access_policy2" {
  name = "s3_full_access_policy"
  user = aws_iam_user.example_user2.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
EOF
}

# To create IAM user ChangePasswordPolicy for user-2
resource "aws_iam_user_policy" "example_user_policy2" {
  name       = "ChangePasswordPolicy"
  user       = aws_iam_user.example_user.name
  policy     = <<-EOF
{
  "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:ChangePassword"
            ],
            "Resource": [
                "arn:aws:iam::*:user/node_user2"
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

# To create get AMI
data "aws_caller_identity" "current" {}

# To create KSM key
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
            "Sid": "Allow access for Key Administrators",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/admin_user"
            },
            "Action": [
                "kms:Create*",
                "kms:Describe*",
                "kms:Enable*",
                "kms:List*",
                "kms:Put*",
                "kms:Update*",
                "kms:Revoke*",
                "kms:Disable*",
                "kms:Get*",
                "kms:Delete*",
                "kms:TagResource",
                "kms:UntagResource",
                "kms:ScheduleKeyDeletion",
                "kms:CancelKeyDeletion"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow use of the key1",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/node_user1"
                ]
            },
            "Action": [
                "kms:Encrypt"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow use of the key2",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/node_user2"
                ]
            },
            "Action": [
                "kms:Decrypt"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow attachment of persistent resources",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/node_user1",
                    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/node_user2"
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