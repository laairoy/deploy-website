output "website-host" {
  value = aws_s3_bucket_website_configuration.website_configuration.website_endpoint

}
