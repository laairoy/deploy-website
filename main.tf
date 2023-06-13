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
