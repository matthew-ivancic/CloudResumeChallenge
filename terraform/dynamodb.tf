resource "aws_dynamodb_table" "API_table" {
  name         = "${var.bucket_name}-VisitorCount"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "stat"

  attribute {
    name = "stat"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "visitor_count" {
  table_name = aws_dynamodb_table.API_table.name
  hash_key   = aws_dynamodb_table.API_table.hash_key

  item = <<ITEM
  {
    "stat": {"S": "Quantity"},
    "viewCount": {"N":"0"}
  }
ITEM
}
