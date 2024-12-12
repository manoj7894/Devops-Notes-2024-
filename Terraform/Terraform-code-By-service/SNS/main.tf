# How to get Notification when you upload the file in S3  [This is one way this way is working]
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "manoj-9018"
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


data "aws_caller_identity" "current" {}

resource "aws_sns_topic" "example_topic" {
  name                        = "some-topic"
  display_name                = "Example Topic"
  fifo_topic                  = false
  content_based_deduplication = false

  policy = <<POLICY
  {
      "Version":"2012-10-17",
      "Statement":[{
          "Effect": "Allow",
          "Principal": {"Service":"s3.amazonaws.com"},
          "Action": "SNS:Publish",
          "Resource":  "arn:aws:sns:${var.region}:${data.aws_caller_identity.current.account_id}:some-topic",
          "Condition":{
              "ArnLike":{"aws:SourceArn":"${aws_s3_bucket.my_bucket.arn}"}
          }
      }]
  }
  POLICY
}

resource "aws_sns_topic_subscription" "example_subscription" {
  topic_arn = aws_sns_topic.example_topic.arn
  protocol  = "email"
  endpoint  = "varmapotthuri4@gmail.com" # Replace with your email address
}

resource "aws_s3_bucket_notification" "s3_notif" {
  bucket = aws_s3_bucket.my_bucket.id

  topic {
    topic_arn = aws_sns_topic.example_topic.arn

    events = [
      "s3:ObjectCreated:*",
      "s3:ObjectRemoved:Delete",
      "s3:ObjectRemoved:DeleteMarkerCreated",
    ]

  }
}





# How to create Event bridge with any state and any instances  [Not working]
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_sns_topic" "example_topic" {
  name                        = "example-topic"
  display_name                = "Example Topic"
  fifo_topic                  = false
  content_based_deduplication = false
}

resource "aws_sns_topic_subscription" "example_subscription" {
  topic_arn = aws_sns_topic.example_topic.arn
  protocol  = "email"
  endpoint  = "varmapotthuri4@gmail.com" # Replace with your email address
}

resource "aws_cloudwatch_event_rule" "example_rule" {
  name        = "my-rule"
  description = "My EventBridge Rule"

  event_pattern = <<PATTERN
  {
    "source": ["aws.ec2"],
    "detail-type": ["EC2 Instance State-change Notification"]
  }
  PATTERN
}

resource "aws_cloudwatch_event_target" "example_target" {
  rule      = aws_cloudwatch_event_rule.example_rule.name
  arn       = aws_sns_topic.example_topic.arn # Replace with your SNS topic ARN
  target_id = "example-target-id"
}




# How to create Event bridge with specific state with all instances  [Not working]
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_sns_topic" "example_topic" {
  name                        = "example-topic"
  display_name                = "Example Topic"
  fifo_topic                  = false
  content_based_deduplication = false
}

resource "aws_sns_topic_subscription" "example_subscription" {
  topic_arn = aws_sns_topic.example_topic.arn
  protocol  = "email"
  endpoint  = "varmapotthuri4@gmail.com" # Replace with your email address
}

resource "aws_cloudwatch_event_rule" "example_rule" {
  name        = "my-rule"
  description = "My EventBridge Rule"

  event_pattern = <<PATTERN
  {
    "source": ["aws.ec2"],
    "detail-type": ["EC2 Instance State-change Notification"],
    "detail": {
      "state": ["stopping", "stopped"]
    }
  }
  PATTERN
}

resource "aws_cloudwatch_event_target" "example_target" {
  rule      = aws_cloudwatch_event_rule.example_rule.name
  arn       = aws_sns_topic.example_topic.arn # Replace with your SNS topic ARN
  target_id = "example-target-id"
}





# How to create Event bridge with specific state with specific instances  [Not working]
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_sns_topic" "example_topic" {
  name                        = "example-topic"
  display_name                = "Example Topic"
  fifo_topic                  = false
  content_based_deduplication = false
}

resource "aws_sns_topic_subscription" "example_subscription" {
  topic_arn = aws_sns_topic.example_topic.arn
  protocol  = "email"
  endpoint  = "varmapotthuri4@gmail.com" # Replace with your email address
}

resource "aws_cloudwatch_event_rule" "example_rule" {
  name        = "my-rule"
  description = "My EventBridge Rule"

  event_pattern = <<PATTERN
  {
    "source": ["aws.ec2"],
    "detail-type": ["EC2 Instance State-change Notification"],
    "detail": {
      "state": ["stopping", "stopped"],
      "instance-id": ["i-069988b6dde85b238"]
    }
  }
  PATTERN
}

resource "aws_cloudwatch_event_target" "example_target" {
  rule      = aws_cloudwatch_event_rule.example_rule.name
  arn       = aws_sns_topic.example_topic.arn # Replace with your SNS topic ARN
  target_id = "example-target-id"
}



# How to create Event bridge with specific state with specific instances with particular time [Not working]
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_sns_topic" "example_topic" {
  name                        = "example-topic"
  display_name                = "Example Topic"
  fifo_topic                  = false
  content_based_deduplication = false
}

resource "aws_sns_topic_subscription" "example_subscription" {
  topic_arn = aws_sns_topic.example_topic.arn
  protocol  = "email"
  endpoint  = "varmapotthuri4@gmail.com" # Replace with your email address
}

resource "aws_cloudwatch_event_rule" "example_rule" {
  name        = "my-rule"
  description = "My EventBridge Rule"

  event_pattern = <<PATTERN
  {
    "source": ["aws.ec2"],
    "detail-type": ["EC2 Instance State-change Notification"],
    "detail": {
      "state": ["stopping", "stopped"],
      "instance-id": ["i-069988b6dde85b238"]
    }
  }
  PATTERN
  // Use a rate expression (e.g., trigger the rule every 2 hours)
  schedule_expression = "rate(2 minutes)"
  #schedule_expression = "cron(0/2 * * * ? *)"
}

resource "aws_cloudwatch_event_target" "example_target" {
  rule      = aws_cloudwatch_event_rule.example_rule.name
  arn       = aws_sns_topic.example_topic.arn # Replace with your SNS topic ARN
  target_id = "example-target-id"
}






# How to get the notification when we upload the file in s3 Bucket [Not working] [second way]
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_sns_topic" "example_topic" {
  name                        = "example-topic"
  display_name                = "Example Topic"
  fifo_topic                  = false
  content_based_deduplication = false
}

resource "aws_sns_topic_subscription" "example_subscription" {
  topic_arn = aws_sns_topic.example_topic.arn
  protocol  = "email"
  endpoint  = "varmapotthuri4@gmail.com" # Replace with your email address
}

resource "aws_cloudwatch_event_rule" "example_rule" {
  name        = "my-rule"
  description = "My EventBridge Rule"

  event_pattern = <<PATTERN
  {
    "source": ["aws.s3"],
    "detail-type": ["Object Access Tier Changed", "Object ACL Updated", "Object Created", "Object Deleted", "Object Restore Completed", "Object Restore Expired", "Object Restore Initiated", "Object Storage Class Changed", "Object Tags Added", "Object Tags Deleted"],
    "detail": {
      "bucket": {
        "name": ["manoj-9044"]
      }
    }
  }
  PATTERN
}

resource "aws_cloudwatch_event_target" "example_target" {
  rule      = aws_cloudwatch_event_rule.example_rule.name
  arn       = aws_sns_topic.example_topic.arn # Replace with your SNS topic ARN
  target_id = "example-target-id"
}




# How get the SNS notification by s3 and create s3 bucket with public [Not working] [second way]
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "manoj-9045"
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

data "aws_caller_identity" "current" {}

resource "aws_sns_topic" "example_topic" {
  name                        = "example-topic"
  display_name                = "Example Topic"
  fifo_topic                  = false
  content_based_deduplication = false

  policy = <<POLICY
  {
      "Version":"2012-10-17",
      "Statement":[{
          "Effect": "Allow",
          "Principal": {"Service":"s3.amazonaws.com"},
          "Action": "SNS:Publish",
          "Resource":  "arn:aws:sns:${var.region}:${data.aws_caller_identity.current.account_id}:example-topic",
          "Condition":{
              "ArnLike":{"aws:SourceArn":"${aws_s3_bucket.my_bucket.arn}"}
          }
      }]
  }
  POLICY

}

resource "aws_sns_topic_subscription" "example_subscription" {
  topic_arn = aws_sns_topic.example_topic.arn
  protocol  = "email"
  endpoint  = "varmapotthuri4@gmail.com" # Replace with your email address
}

resource "aws_cloudwatch_event_rule" "example_rule" {
  name        = "my-rule"
  description = "My EventBridge Rule"

  event_pattern = <<PATTERN
  {
    "source": ["aws.s3"],
    "detail-type": ["Object Access Tier Changed", "Object ACL Updated", "Object Created", "Object Deleted", "Object Restore Completed", "Object Restore Expired", "Object Restore Initiated", "Object Storage Class Changed", "Object Tags Added", "Object Tags Deleted"],
    "detail": {
      "bucket": {
        "name": ["${aws_s3_bucket.my_bucket.bucket}"]
      }
    }
  }
  PATTERN
}

resource "aws_cloudwatch_event_target" "example_target" {
  rule      = aws_cloudwatch_event_rule.example_rule.name
  arn       = aws_sns_topic.example_topic.arn # Replace with your SNS topic ARN
  target_id = "example-target-id"
}






# Example
# How to create Event bridge with any state and any instances  [Not working]
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_sns_topic" "example_topic" {
  name                        = "example-topic"
  display_name                = "Example Topic"
  fifo_topic                  = false
  content_based_deduplication = false
}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.example_topic.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.example_topic.arn]
  }
}


resource "aws_sns_topic_subscription" "example_subscription" {
  topic_arn = aws_sns_topic.example_topic.arn
  protocol  = "email"
  endpoint  = "varmapotthuri4@gmail.com" # Replace with your email address
}

data "aws_caller_identity" "current" {}

resource "aws_cloudwatch_event_rule" "example_rule" {
  name        = "my-rule"
  description = "My EventBridge Rule"

  event_pattern = <<PATTERN
  {
    "source": ["aws.ec2"],
    "account":["${data.aws_caller_identity.current.account_id}"],
    "region":["${var.region}"],
    "resources":[
      "arn:aws:ec2:${var.region}:${data.aws_caller_identity.current.account_id}:instance/i-abcd1111"
    ],
    "detail-type": ["EC2 Instance State-change Notification"]
  }
  PATTERN
}

resource "aws_cloudwatch_event_target" "example_target" {
  rule      = aws_cloudwatch_event_rule.example_rule.name
  arn       = aws_sns_topic.example_topic.arn # Replace with your SNS topic ARN
  target_id = "example-target-id"
}














resource "aws_sns_topic_policy" "example_topic_policy" {
  arn = aws_sns_topic.example_topic.arn

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "example-topic-policy",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "sns:*",
        Resource  = aws_sns_topic.example_topic.arn,
        Condition = {
          ArnLike = {
            "aws:SourceArn" = aws_s3_bucket.my_bucket.arn
          },
        },
      },
    ],
  })
}


resource "aws_sns_topic_policy" "example_topic_policy" {
  arn = aws_sns_topic.example_topic.arn

  policy = jsonencode({
    Version = "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": { 
        "Service": "s3.amazonaws.com" 
      },
      "Action": "sns:Publish",
      "Resource": "arn:aws:sns:ap-south-1:254669244016:MyTopic",
      "Condition": {
        "StringEquals": {
          "AWS:SourceAccount": "444455556666"
        }       
      }
    }]
  })
}




# Configure S3 bucket notifications to send events to SNS topic
resource "aws_s3_bucket_notification" "example_bucket_notification" {
  bucket = aws_s3_bucket.my_bucket.bucket

  topic {
    topic_arn     = aws_sns_topic.example_topic.arn
    events        = ["s3:*:*"]  # Trigger on any object creation event
    filter_prefix = ""  # Optionally, set a filter prefix
    filter_suffix = ""  # Optionally, set a filter suffix
  }
}





