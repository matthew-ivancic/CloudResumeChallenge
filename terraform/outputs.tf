output "dynamodb_table_name" {
  description = "Name of the DynamoDB table for visitor count"
  value       = aws_dynamodb_table.API_table.name
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.API_table.arn
}

output "cloudfront_distribution_domain" {
  description = "Domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.www_s3_distribution.domain_name
}

output "website_url" {
  description = "URL of the website"
  value       = "https://${var.domain_name}"
}

output "api_gateway_url" {
  description = "URL of the API Gateway endpoint"
  value       = "https://${aws_api_gateway_rest_api.crc_api.id}.execute-api.${data.aws_region.current.name}.amazonaws.com/prod"
}

data "aws_region" "current" {}
