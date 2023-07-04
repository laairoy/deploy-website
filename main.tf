terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.2.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = var.region
  default_tags {
    tags = local.common_tags
  }
}

provider "aws" {
  alias  = "n_virginia"
  region = var.cloudFront_region
  default_tags {
    tags = local.common_tags
  }
}

module "bucket" {
  source = "git@github.com:laairoy/terraform-s3-bucket.git"

  bucket        = var.domain_name
  force_destroy = true
  public_access = true

  website = {
    //index_document = "index.html"
    redirect = {
      host_name = "www.${var.domain_name}"
      protocol  = "https"
    }
  }
}

module "cf_distribution" {
  source = "./modules/cf_s3_distribution"
  origin = {
    origin_id = module.bucket.bucket_website_name
    //origin_access_control_id = aws_cloudfront_origin_access_control.cf_origin.id
    domain_name = module.bucket.bucket_website_endpoint
  }

  //default_root_object = "index.html"
  aliases             = [module.bucket.bucket_website_name]
  acm_certificate_arn = aws_acm_certificate.cert.arn
}

