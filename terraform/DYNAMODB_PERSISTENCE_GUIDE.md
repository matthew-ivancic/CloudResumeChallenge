# DynamoDB Persistence Guide

## Problem: Terraform Resets DynamoDB Data

When using `aws_dynamodb_table_item` in Terraform, the data gets reset to the defined state every time you run `terraform apply`. This is problematic for data that should persist between deployments.

## Solution: Remove Terraform Management of Data

### What We Changed:

1. **Removed `aws_dynamodb_table_item`** from Terraform configuration
2. **Created initialization script** that only creates data if it doesn't exist
3. **Added Terraform outputs** for better resource management

### Benefits:

- ✅ **Data Persistence**: Visitor count won't reset on deployments
- ✅ **Flexible Management**: Data can be managed outside of Terraform
- ✅ **Safe Initialization**: Script only creates initial data if needed
- ✅ **Better Control**: You can manage data lifecycle separately

## How It Works Now:

### 1. Terraform Manages Infrastructure Only
```hcl
resource "aws_dynamodb_table" "API_table" {
  name         = "${var.bucket_name}-VisitorCount"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "stat"

  attribute {
    name = "stat"
    type = "S"
  }
}
# No aws_dynamodb_table_item - data is managed separately
```

### 2. Data Initialization Script
The `init-dynamodb.sh` script:
- Checks if visitor count item exists
- Only creates it if it doesn't exist
- Preserves existing data

### 3. Lambda Function Manages Data
Your Lambda function continues to:
- Read current visitor count
- Increment it
- Write back to DynamoDB

## Usage:

### Initial Setup:
```bash
# Run after first terraform apply
./init-dynamodb.sh
```

### Check Current Status:
```bash
# View current visitor count
aws dynamodb get-item \
  --table-name "resume.mivancic.com-VisitorCount" \
  --key '{"stat": {"S": "Quantity"}}' \
  --query 'Item.viewCount.N' \
  --output text
```

### Manual Data Management:
```bash
# Set visitor count to specific value
aws dynamodb put-item \
  --table-name "resume.mivancic.com-VisitorCount" \
  --item '{"stat": {"S": "Quantity"}, "viewCount": {"N": "100"}}'

# Reset visitor count to 0
aws dynamodb put-item \
  --table-name "resume.mivancic.com-VisitorCount" \
  --item '{"stat": {"S": "Quantity"}, "viewCount": {"N": "0"}}'
```

## Alternative Solutions:

### Option 1: Use Terraform with Lifecycle Rules
```hcl
resource "aws_dynamodb_table_item" "visitor_count" {
  table_name = aws_dynamodb_table.API_table.name
  hash_key   = aws_dynamodb_table.API_table.hash_key

  item = <<ITEM
  {
    "stat": {"S": "Quantity"},
    "viewCount": {"N":"0"}
  }
ITEM

  lifecycle {
    ignore_changes = [item]
  }
}
```

### Option 2: Use Terraform with Conditional Creation
```hcl
resource "aws_dynamodb_table_item" "visitor_count" {
  count      = var.create_initial_data ? 1 : 0
  table_name = aws_dynamodb_table.API_table.name
  hash_key   = aws_dynamodb_table.API_table.hash_key

  item = <<ITEM
  {
    "stat": {"S": "Quantity"},
    "viewCount": {"N":"0"}
  }
ITEM
}
```

## Best Practices:

1. **Separate Infrastructure from Data**: Use Terraform for infrastructure, scripts for data
2. **Use Lifecycle Rules**: If you must use Terraform for data, use `ignore_changes`
3. **Backup Important Data**: Regularly backup DynamoDB data
4. **Monitor Data Changes**: Set up CloudWatch alarms for data changes
5. **Document Data Management**: Keep scripts and procedures documented

## Migration Steps:

If you have existing data you want to preserve:

1. **Backup current data**:
   ```bash
   aws dynamodb get-item \
     --table-name "resume.mivancic.com-VisitorCount" \
     --key '{"stat": {"S": "Quantity"}}' > backup.json
   ```

2. **Apply Terraform changes** (removes the table item resource)

3. **Restore data** (if needed):
   ```bash
   aws dynamodb put-item \
     --table-name "resume.mivancic.com-VisitorCount" \
     --item file://backup.json
   ```

## Monitoring:

Set up CloudWatch alarms to monitor:
- DynamoDB table metrics
- Lambda function invocations
- API Gateway requests
- Visitor count changes
