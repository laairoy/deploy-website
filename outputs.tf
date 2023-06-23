output "website-host" {
  value = aws_s3_bucket_website_configuration.website_configuration.website_endpoint
}

output "cloudfront-distribution" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}
