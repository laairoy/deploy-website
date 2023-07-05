module "bucket_root" {
  source = "git@github.com:laairoy/terraform-s3-bucket.git"

  bucket        = var.domain_name
  force_destroy = true
  public_access = true

  website = {
    redirect = {
      host_name = "www.${var.domain_name}"
      protocol  = "https"
    }
  }
}

module "bucket_www" {
  source = "git@github.com:laairoy/terraform-s3-bucket.git"

  bucket        = "www.${var.domain_name}"
  force_destroy = true
  public_access = true

  website = {
    index_document = "index.html"
  }
}
