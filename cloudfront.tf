module "cf_distribution_root" {
  source = "./modules/cf_s3_distribution"
  origin = {
    origin_id   = module.bucket_root.bucket_website_name
    domain_name = module.bucket_root.bucket_website_endpoint
  }

  aliases             = [module.bucket_root.bucket_website_name]
  acm_certificate_arn = aws_acm_certificate.cert.arn
}

module "cf_distribution_www" {
  source = "./modules/cf_s3_distribution"
  origin = {
    origin_id                = module.bucket_www.bucket_website_name
    origin_access_control_id = aws_cloudfront_origin_access_control.cf_origin.id
    domain_name              = module.bucket_www.bucket_regional_domain_name
  }

  default_root_object = "index.html"
  aliases             = [module.bucket_www.bucket_website_name]
  acm_certificate_arn = aws_acm_certificate.cert.arn
}

resource "aws_cloudfront_origin_access_control" "cf_origin" {
  name                              = "cf-origin"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
