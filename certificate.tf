resource "aws_acm_certificate" "cert" {
  provider                  = aws.n_virginia
  domain_name               = "laai.com.br"
  subject_alternative_names = ["*.laai.com.br"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}
