resource "aws_dynamodb_table" "metadata" {
  name             = join("-", ["ObjectMetadata", var.environment])
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "id"    # partition key of the item
  stream_enabled   = true    # capture the time and order the sequence of data
  stream_view_type = "NEW_AND_OLD_IMAGES"   # it will record the unique sequence number

  attribute {
    name = "id"
    type = "S"
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.my_kms_key.arn
  }

}