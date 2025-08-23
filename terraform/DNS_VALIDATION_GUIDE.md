# DNS Validation Guide for SSL Certificates

## What is DNS Validation?

DNS validation is an automated method for validating SSL certificates that verifies domain ownership by checking DNS records. It's faster and more reliable than email validation.

## How It Works

1. **Certificate Request**: When you request an SSL certificate, AWS ACM generates CNAME records
2. **DNS Records**: AWS provides specific CNAME records that need to be added to your domain's DNS
3. **Automated Check**: AWS automatically verifies the DNS records exist
4. **Certificate Issuance**: Certificate is issued once validation is complete

## Implementation in Terraform

### 1. Update ACM Certificate Configuration

```hcl
resource "aws_acm_certificate" "ssl_certificate" {
  provider                  = aws.acm_provider
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"  # Changed from EMAIL to DNS

  lifecycle {
    create_before_destroy = true
  }
}
```

### 2. Add DNS Validation Records

```hcl
# DNS validation records for the main domain
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.ssl_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.main.zone_id
}
```

### 3. Update Certificate Validation

```hcl
resource "aws_acm_certificate_validation" "cert_validation" {
  provider                = aws.acm_provider
  certificate_arn         = aws_acm_certificate.ssl_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}
```

## Advantages of DNS Validation

- ✅ **Faster**: Usually completes within minutes
- ✅ **Automated**: No manual email clicking required
- ✅ **Reliable**: Works even if email validation fails
- ✅ **CI/CD Friendly**: Can be fully automated in pipelines
- ✅ **No Expiration**: DNS records can remain for future renewals

## Migration Steps

### If you have an existing EMAIL-validated certificate:

1. **Destroy the old certificate**:
   ```bash
   terraform destroy -target=aws_acm_certificate_validation.cert_validation -auto-approve
   terraform destroy -target=aws_acm_certificate.ssl_certificate -auto-approve
   ```

2. **Apply the new DNS validation configuration**:
   ```bash
   terraform apply -auto-approve
   ```

3. **Monitor the validation**:
   - Check the AWS Console for certificate status
   - DNS validation typically completes within 5-30 minutes

## Troubleshooting

### Common Issues:

1. **DNS Propagation**: DNS changes can take up to 48 hours to propagate globally
2. **TTL Settings**: Lower TTL values (60 seconds) help with faster propagation
3. **Zone ID**: Ensure the Route53 zone ID is correct
4. **Record Names**: Verify the CNAME record names match exactly

### Verification Commands:

```bash
# Check certificate status
aws acm describe-certificate --certificate-arn <certificate-arn>

# Check DNS records
dig <validation-record-name> CNAME

# Check Route53 records
aws route53 list-resource-record-sets --hosted-zone-id <zone-id>
```

## Best Practices

1. **Use Route53**: DNS validation works best with Route53 hosted zones
2. **Keep Records**: Don't delete validation records after certificate issuance
3. **Monitor Expiration**: Set up alerts for certificate expiration
4. **Automate Renewal**: DNS validation enables automatic renewal
