#!/bin/bash

# Script to fix expired SSL certificate with DNS validation
# This script will destroy the expired certificate and recreate it using DNS validation

echo "Starting certificate fix process with DNS validation..."

# Step 1: Destroy the certificate validation resource
echo "Destroying certificate validation resource..."
terraform destroy -target=aws_acm_certificate_validation.cert_validation -auto-approve

# Step 2: Destroy the certificate itself
echo "Destroying expired certificate..."
terraform destroy -target=aws_acm_certificate.ssl_certificate -auto-approve

# Step 3: Apply to recreate the certificate with DNS validation
echo "Recreating certificate with DNS validation..."
terraform apply -auto-approve

echo "Certificate fix process completed!"
echo ""
echo "DNS Validation Status:"
echo "======================"
echo "1. Terraform will automatically create DNS validation records in Route53"
echo "2. AWS will automatically verify the DNS records within 5-30 minutes"
echo "3. You can monitor the certificate status in the AWS Console"
echo "4. No manual intervention required!"
echo ""
echo "To check certificate status:"
echo "aws acm describe-certificate --certificate-arn <certificate-arn>"
echo ""
echo "To check DNS validation records:"
echo "aws route53 list-resource-record-sets --hosted-zone-id <zone-id>"
