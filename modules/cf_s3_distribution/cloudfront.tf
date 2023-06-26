
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = var.origin.domain_name
    origin_access_control_id = var.origin.origin_access_control_id
    origin_id                = var.origin.origin_id

    dynamic "custom_origin_config" {
      for_each = var.origin.origin_access_control_id == null ? [1] : []

      content {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "http-only"
        origin_ssl_protocols = [
          "TLSv1.2",
        ]

      }
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  //comment             = ""
  default_root_object = var.default_root_object

  aliases = var.aliases

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.origin.origin_id

    viewer_protocol_policy = "redirect-to-https"


    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }
}
