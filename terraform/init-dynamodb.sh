#!/bin/bash

# Script to initialize DynamoDB table with initial visitor count
# This script only creates the item if it doesn't exist, preserving existing data

echo "🔧 Initializing DynamoDB table..."

# Get the table name from terraform output or use default
TABLE_NAME="resume.mivancic.com-VisitorCount"

# Check if the item already exists
echo "Checking if visitor count item exists..."
EXISTING_ITEM=$(aws dynamodb get-item \
  --table-name "$TABLE_NAME" \
  --key '{"stat": {"S": "Quantity"}}' \
  --query 'Item' \
  --output text 2>/dev/null)

if [ "$EXISTING_ITEM" = "None" ] || [ -z "$EXISTING_ITEM" ]; then
  echo "Creating initial visitor count item..."
  aws dynamodb put-item \
    --table-name "$TABLE_NAME" \
    --item '{"stat": {"S": "Quantity"}, "viewCount": {"N": "0"}}'
  echo "✅ Initial visitor count created"
else
  echo "✅ Visitor count item already exists, skipping initialization"
  echo "Current visitor count: $(aws dynamodb get-item \
    --table-name "$TABLE_NAME" \
    --key '{"stat": {"S": "Quantity"}}' \
    --query 'Item.viewCount.N' \
    --output text)"
fi

echo ""
echo "📊 Current DynamoDB table status:"
aws dynamodb describe-table --table-name "$TABLE_NAME" --query 'Table.{Name:TableName,Status:TableStatus,ItemCount:ItemCount}' --output table
