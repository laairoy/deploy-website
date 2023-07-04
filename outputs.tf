/*
output "website-host" {
  value = aws_s3_bucket_website_configuration.website_configuration.website_endpoint
}
*/

output "cloudfront_distribution_root" {
  value = module.cf_distribution.cloudfront_distribution_domain
}

output "cloudfront_distribution_www" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "acm_certificate_validation" {
  value = aws_acm_certificate.cert.domain_validation_options
}
