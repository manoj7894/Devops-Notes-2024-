# To create S3 bucket with acl private
# To create S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "manoj-9088"
  acl    = "private" # Set the ACL to private for restricted access

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.my_kms_key.key_id
      }
    }
  }
}


# To create S3 bucket with acl public
# To create S3 bucket with server_side_encryption_configuration
resource "aws_s3_bucket" "my_bucket" {
  bucket = "manoj-9088"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.my_kms_key.key_id
      }
    }
  }
}

# To create the s3 bucket ownership_controls
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.my_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# To create ss3_bucket_public_access_block
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# To create s3 bucket ACL permission
resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.my_bucket.id
  acl    = "public-read"
}





# How to create s3 bucket with particular user
# To create S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "manoj-9056"
  acl    = "private"  # This line is optional and may not be needed, depending on your use case

  # ... other bucket configuration ...

  # Attach a bucket policy
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_user.example_user.arn}"
      },
      "Action": "*",
      "Resource": "*"
    }
  ]
}
EOF

   server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.my_kms_key.key_id
      }
    }
  }
}


