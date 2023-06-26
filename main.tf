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

  bucket        = "laai.com.br"
  force_destroy = true
  public_access = true

  website = {
    //index_document = "index.html"
    redirect = {
      host_name = "www.laai.com.br"
      protocol  = "https"
    }
  }
}
