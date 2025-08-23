#!/bin/bash

# Diagnostic script to check certificate and CloudFront status

echo "🔍 Checking Certificate and CloudFront Status..."
echo "================================================"

# Get the certificate ARN from the last apply
CERT_ARN="arn:aws:acm:us-east-1:790872857243:certificate/5985d6af-c645-49f5-a778-7d37464855c1"

echo ""
echo "📋 Certificate Status:"
echo "----------------------"
aws acm describe-certificate --certificate-arn "$CERT_ARN" --region us-east-1 --query 'Certificate.{Status:Status,DomainName:DomainName,SubjectAlternativeNames:SubjectAlternativeNames,IssuedAt:IssuedAt,NotAfter:NotAfter}' --output table

echo ""
echo "🌐 CloudFront Distributions:"
echo "----------------------------"
aws cloudfront list-distributions --query 'DistributionList.Items[?contains(Aliases.Items, `resume.mivancic.com`) || contains(Aliases.Items, `www.resume.mivancic.com`)].{Id:Id,DomainName:DomainName,Status:Status,Aliases:Aliases.Items}' --output table

echo ""
echo "📡 Route53 Records:"
echo "-------------------"
ZONE_ID="Z08894482TMBL6LJ2OXQ9"
aws route53 list-resource-record-sets --hosted-zone-id "$ZONE_ID" --query 'ResourceRecordSets[?Name==`resume.mivancic.com.` || Name==`www.resume.mivancic.com.`].{Name:Name,Type:Type,TTL:TTL,AliasTarget:AliasTarget}' --output table

echo ""
echo "🔗 DNS Validation Records:"
echo "-------------------------"
aws route53 list-resource-record-sets --hosted-zone-id "$ZONE_ID" --query 'ResourceRecordSets[?contains(Name, `_e6f8725e5befed5730be63d44247afa8`)].{Name:Name,Type:Type,TTL:TTL,Records:ResourceRecords[0].Value}' --output table

echo ""
echo "🌍 Testing Website Access:"
echo "-------------------------"
echo "Testing resume.mivancic.com..."
curl -I -s https://resume.mivancic.com | head -5
echo ""
echo "Testing www.resume.mivancic.com..."
curl -I -s https://www.resume.mivancic.com | head -5

echo ""
echo "📊 Summary:"
echo "-----------"
echo "1. Check if certificate status shows 'ISSUED'"
echo "2. Verify CloudFront distributions are 'Deployed'"
echo "3. Confirm Route53 records point to CloudFront"
echo "4. DNS propagation can take up to 48 hours"
echo "5. Try accessing the site in an incognito browser"
