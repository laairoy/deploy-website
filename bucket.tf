resource "aws_s3_bucket" "bucket-website" {
  bucket        = local.domain_name.domain
  force_destroy = true
}

resource "aws_s3_bucket_website_configuration" "website_configuration" {
  bucket = aws_s3_bucket.bucket-website.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "allow_website_public_access" {
  depends_on = [aws_s3_bucket_ownership_controls.bucket_website_acl_ownership]
  bucket     = aws_s3_bucket.bucket-website.id
  policy     = data.aws_iam_policy_document.allow_public_access.json
}

data "aws_iam_policy_document" "allow_public_access" {
  statement {
    sid    = "PublicReadGetObject"
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]

    }
    actions = [
      "s3:GetObject",
    ]

    resources = [
      aws_s3_bucket.bucket-website.arn,
      "${aws_s3_bucket.bucket-website.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_ownership_controls" "bucket_website_acl_ownership" {
  bucket = aws_s3_bucket.bucket-website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "access_block" {
  bucket = aws_s3_bucket.bucket-website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "bucket_website_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.bucket_website_acl_ownership, aws_s3_bucket_public_access_block.access_block]
  bucket     = aws_s3_bucket.bucket-website.id
  acl        = "public-read"
}
