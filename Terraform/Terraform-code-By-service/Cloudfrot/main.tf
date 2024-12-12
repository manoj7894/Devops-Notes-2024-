# How to create Cloud front without any encryption
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_cloudtrail" "cloudtrail" {
  name                          = "tf-cloudtrail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_bucket.id
  s3_key_prefix                 = "cloudtrail"
  include_global_service_events = true
  enable_log_file_validation    = true
  is_multi_region_trail         = true
  depends_on = [aws_s3_bucket_policy.CloudTrailS3Bucket, aws_s3_bucket.cloudtrail_bucket]

  event_selector {
    read_write_type           = "All"
    include_management_events = true
    #data_resource {
    #  type   = "AWS::S3::Object"
    #  values = ["arn:aws:s3:::your-unique-bucket-name/*"]
    #}
  }

}

resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket        = "manoj-7865"
  force_destroy = true
  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_policy" "CloudTrailS3Bucket" {
  bucket = aws_s3_bucket.cloudtrail_bucket.bucket
  depends_on = [aws_s3_bucket.cloudtrail_bucket]
  policy = <<POLICY
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "cloudtrail.amazonaws.com"
          },
          "Action": [
            "s3:GetBucketAcl",
            "s3:PutObject",
            "s3:ListBucket"
          ],
          "Resource": [
            "arn:aws:s3:::${aws_s3_bucket.cloudtrail_bucket.bucket}",
            "arn:aws:s3:::${aws_s3_bucket.cloudtrail_bucket.bucket}/*"
          ]
        }
      ]
    }
  POLICY
}




# How to create cloudfront with default S3 encryption
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_cloudtrail" "cloudtrail" {
  name                          = "tf-cloudtrail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_bucket.id
  s3_key_prefix                 = "cloudtrail"
  include_global_service_events = true
  enable_log_file_validation    = true
  is_multi_region_trail         = true
  depends_on = [aws_s3_bucket_policy.CloudTrailS3Bucket, aws_s3_bucket.cloudtrail_bucket]

  event_selector {
    read_write_type           = "All"
    include_management_events = true
    #data_resource {
    #  type   = "AWS::S3::Object"
    #  values = ["arn:aws:s3:::your-unique-bucket-name/*"]
    #}
  }

}

resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket        = "manoj-7865"
  force_destroy = true
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_policy" "CloudTrailS3Bucket" {
  bucket = aws_s3_bucket.cloudtrail_bucket.bucket
  depends_on = [aws_s3_bucket.cloudtrail_bucket]
  policy = <<POLICY
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "cloudtrail.amazonaws.com"
          },
          "Action": [
            "s3:GetBucketAcl",
            "s3:PutObject",
            "s3:ListBucket"
          ],
          "Resource": [
            "arn:aws:s3:::${aws_s3_bucket.cloudtrail_bucket.bucket}",
            "arn:aws:s3:::${aws_s3_bucket.cloudtrail_bucket.bucket}/*"
          ]
        }
      ]
    }
  POLICY
}



# How to create cloud front with KMS encryption
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_cloudtrail" "cloudtrail" {
  name                          = "tf-Trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_bucket.id
  s3_key_prefix                 = "cloudtrail"
  include_global_service_events = true
  enable_log_file_validation    = true
  is_multi_region_trail         = true
  kms_key_id                    = aws_kms_key.my_kms_key.arn
  depends_on = [aws_s3_bucket_policy.CloudTrailS3Bucket, aws_s3_bucket.cloudtrail_bucket]

  event_selector {
    read_write_type           = "All"
    include_management_events = true
    #data_resource {
    #  type   = "AWS::S3::Object"
    #  values = ["arn:aws:s3:::your-unique-bucket-name/*"]
    #}
  }

}

resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket = "manoj-8712"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.cloudtrail_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.my_kms_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_policy" "CloudTrailS3Bucket" {
  bucket = aws_s3_bucket.cloudtrail_bucket.bucket
  depends_on = [aws_s3_bucket.cloudtrail_bucket]
  policy = <<POLICY
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "cloudtrail.amazonaws.com"
          },
          "Action": [
            "s3:GetBucketAcl",
            "s3:PutObject",
            "s3:ListBucket"
          ],
          "Resource": [
            "arn:aws:s3:::${aws_s3_bucket.cloudtrail_bucket.bucket}",
            "arn:aws:s3:::${aws_s3_bucket.cloudtrail_bucket.bucket}/*"
          ]
        }
      ]
    }
  POLICY
}

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
  "Version": "2012-10-17",
  "Id": "Key policy created by CloudTrail",
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
          "Sid": "Allow CloudTrail to encrypt logs",
          "Effect": "Allow",
          "Principal": {
              "Service": "cloudtrail.amazonaws.com"
          },
          "Action": "kms:GenerateDataKey*",
          "Resource": "*",
          "Condition": {
              "StringEquals": {
                  "AWS:SourceArn": "arn:aws:cloudtrail:ap-south-1:${data.aws_caller_identity.current.account_id}:trail/tf-Trail"
              },
              "StringLike": {
                  "kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*"
              }
          }
      },
      {
          "Sid": "Allow CloudTrail to describe key",
          "Effect": "Allow",
          "Principal": {
              "Service": "cloudtrail.amazonaws.com"
          },
          "Action": "kms:DescribeKey",
          "Resource": "*"
      },
      {
          "Sid": "Allow principals in the account to decrypt log files",     
          "Effect": "Allow",
          "Principal": {
              "AWS": "*"                  
          },
          "Action": [
              "kms:Decrypt",
              "kms:ReEncryptFrom"
          ],
          "Resource": "*",
          "Condition": {
              "StringEquals": {
                  "kms:CallerAccount": "${data.aws_caller_identity.current.account_id}"
              },
              "StringLike": {
                  "kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*"
              }
          }
      },
      {
          "Sid": "Allow alias creation during setup",
          "Effect": "Allow",
          "Principal": {
              "AWS": "*"
          },
          "Action": "kms:CreateAlias",
          "Resource": "*",
          "Condition": {
              "StringEquals": {
                  "kms:ViaService": "ec2.ap-south-1.amazonaws.com",
                  "kms:CallerAccount": "${data.aws_caller_identity.current.account_id}"
              }
          }
      },
      {
          "Sid": "Enable cross account log decryption",
          "Effect": "Allow",
          "Principal": {
              "AWS": "*"
          },
          "Action": [
              "kms:Decrypt",
              "kms:ReEncryptFrom"
          ],
          "Resource": "*",
          "Condition": {
              "StringEquals": {
                  "kms:CallerAccount": "${data.aws_caller_identity.current.account_id}"
              },
              "StringLike": {
                  "kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*"
              }
          }
      }
  ]
}
POLICY
}




# How to create cloud front with Cloud logs
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_cloudtrail" "cloudtrail" {
  name                          = "tf-Trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_bucket.id
  s3_key_prefix                 = "cloudtrail"
  include_global_service_events = true
  enable_log_file_validation    = true
  is_multi_region_trail         = true
  kms_key_id                    = aws_kms_key.my_kms_key.arn
  cloud_watch_logs_group_arn    = aws_cloudwatch_log_group.cloudtrail_logs.arn
  cloud_watch_logs_role_arn     = aws_iam_role_policy_attachment.cloudtrail_policy_attachment.arn  # Add this line

  depends_on = [aws_s3_bucket_policy.CloudTrailS3Bucket, aws_s3_bucket.cloudtrail_bucket, aws_iam_role_policy_attachment.cloudtrail_policy_attachment]

  event_selector {
    read_write_type           = "All"
    include_management_events = true
    #data_resource {
    #  type   = "AWS::S3::Object"
    #  values = ["arn:aws:s3:::your-unique-bucket-name/*"]
    #}
  }

}

resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket = "manoj-8712"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.cloudtrail_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.my_kms_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_policy" "CloudTrailS3Bucket" {
  bucket = aws_s3_bucket.cloudtrail_bucket.bucket
  depends_on = [aws_s3_bucket.cloudtrail_bucket]
  policy = <<POLICY
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "cloudtrail.amazonaws.com"
          },
          "Action": [
            "s3:GetBucketAcl",
            "s3:PutObject",
            "s3:ListBucket"
          ],
          "Resource": [
            "arn:aws:s3:::${aws_s3_bucket.cloudtrail_bucket.bucket}",
            "arn:aws:s3:::${aws_s3_bucket.cloudtrail_bucket.bucket}/*"
          ]
        }
      ]
    }
  POLICY
}

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
  "Version": "2012-10-17",
  "Id": "Key policy created by CloudTrail",
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
          "Sid": "Allow CloudTrail to encrypt logs",
          "Effect": "Allow",
          "Principal": {
              "Service": "cloudtrail.amazonaws.com"
          },
          "Action": "kms:GenerateDataKey*",
          "Resource": "*",
          "Condition": {
              "StringEquals": {
                  "AWS:SourceArn": "arn:aws:cloudtrail:ap-south-1:${data.aws_caller_identity.current.account_id}:trail/tf-Trail"
              },
              "StringLike": {
                  "kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*"
              }
          }
      },
      {
          "Sid": "Allow CloudTrail to describe key",
          "Effect": "Allow",
          "Principal": {
              "Service": "cloudtrail.amazonaws.com"
          },
          "Action": "kms:DescribeKey",
          "Resource": "*"
      },
      {
          "Sid": "Allow principals in the account to decrypt log files",     # If you want to give permission to particualr user
          "Effect": "Allow",
          "Principal": {
              "AWS": "*"                  # "arn:aws:iam::USER1_ACCOUNT_ID:user/user1"  # Replace USER1_ACCOUNT_ID with the actual AWS account ID of user1
          },
          "Action": [
              "kms:Decrypt",
              "kms:ReEncryptFrom"
          ],
          "Resource": "*",
          "Condition": {
              "StringEquals": {
                  "kms:CallerAccount": "${data.aws_caller_identity.current.account_id}"
              },
              "StringLike": {
                  "kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*"
              }
          }
      },
      {
          "Sid": "Allow alias creation during setup",
          "Effect": "Allow",
          "Principal": {
              "AWS": "*"
          },
          "Action": "kms:CreateAlias",
          "Resource": "*",
          "Condition": {
              "StringEquals": {
                  "kms:ViaService": "ec2.ap-south-1.amazonaws.com",
                  "kms:CallerAccount": "${data.aws_caller_identity.current.account_id}"
              }
          }
      },
      {
          "Sid": "Enable cross account log decryption",
          "Effect": "Allow",
          "Principal": {
              "AWS": "*"
          },
          "Action": [
              "kms:Decrypt",
              "kms:ReEncryptFrom"
          ],
          "Resource": "*",
          "Condition": {
              "StringEquals": {
                  "kms:CallerAccount": "${data.aws_caller_identity.current.account_id}"
              },
              "StringLike": {
                  "kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*"
              }
          }
      }
  ]
}
POLICY
}

# To create the cloud watch to see logs
resource "aws_cloudwatch_log_group" "cloudtrail_logs" {
  name              = "/aws/lambda/MyLambdaFunction" # Adjust the name to match your Lambda function's name
  retention_in_days = 14
}

resource "aws_iam_role" "cloudtrail_logs" {
  name = "cloudtrail-logs-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


# To create cloud policy role for cloud watch
resource "aws_iam_policy" "cloudtrail_policy" {
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
resource "aws_iam_role_policy_attachment" "cloudtrail_policy_attachment" {
  role       = aws_iam_role.cloudtrail_logs.name
  policy_arn = aws_iam_policy.cloudtrail_policy.arn
}