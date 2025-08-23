resource "aws_dynamodb_table" "API_table" {
  name         = "${var.bucket_name}-VisitorCount"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "stat"

  attribute {
    name = "stat"
    type = "S"
  }
}

# Note: Removed aws_dynamodb_table_item to prevent Terraform from resetting visitor count
# The visitor count will be managed by the Lambda function and persist between deployments
