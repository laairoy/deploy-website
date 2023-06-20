
data "aws_codestarconnections_connection" "github" {
  name = "laairoy-repo"
}

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket        = "pipeline-bucket-mlco"
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "pipe_bucket_acl_ownership" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "codepipeline_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.pipe_bucket_acl_ownership]
  bucket     = aws_s3_bucket.codepipeline_bucket.id
  acl        = "private"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "codepipeline_role" {
  name               = "test-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "codepipeline_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObjectAcl",
      "s3:PutObject",
    ]

    resources = [
      aws_s3_bucket.codepipeline_bucket.arn,
      "${aws_s3_bucket.codepipeline_bucket.arn}/*",
      aws_s3_bucket.bucket-website.arn,
      "${aws_s3_bucket.bucket-website.arn}/*",
    ]
  }

  statement {
    effect    = "Allow"
    actions   = ["codestar-connections:UseConnection"]
    resources = [data.aws_codestarconnections_connection.github.arn]
  }

  statement {
    effect = "Allow"

    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "codepipeline_policy"
  role   = aws_iam_role.codepipeline_role.id
  policy = data.aws_iam_policy_document.codepipeline_policy.json
}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [aws_iam_role_policy.codepipeline_policy]

  create_duration = "10s"
}

resource "aws_codepipeline" "codepipeline" {
  depends_on = [time_sleep.wait_30_seconds]
  name       = "tf-test-pipeline"
  role_arn   = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["package"]

      configuration = {
        ConnectionArn    = data.aws_codestarconnections_connection.github.arn
        FullRepositoryId = "laairoy/projeto-web-cliente"
        BranchName       = "main"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name     = "Deploy"
      category = "Deploy"
      owner    = "AWS"
      provider = "S3"
      #region          = var.region
      input_artifacts = ["package"]
      version         = "1"

      configuration = {
        BucketName = aws_s3_bucket.bucket-website.bucket
        Extract    = "true"
      }
    }
  }
}
