output "cloudfront_distribution_root" {
  value = module.cf_distribution_root.cloudfront_distribution_domain
}

output "cloudfront_distribution_www" {
  value = module.cf_distribution_www.cloudfront_distribution_domain
}

output "acm_certificate_validation" {
  value = aws_acm_certificate.cert.domain_validation_options
}
