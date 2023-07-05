# Deploy Static website with S3

---

This is a Terraform recipe to create an AWS CodePipeline to deploy a static website from GitHub repository to AWS S3, with CloudFront and ACM providing security.

## The recipe consists of four main steps:

1. Create an ACM certificate for the domain name of the website.
2. Create a CloudFront distribution that uses the ACM certificate and points to the S3 bucket as the origin.
3. Create an S3 bucket that will host the website files.
4. Create a CodePipeline that connects to the GitHub repository and triggers and deploy stage whenever there is a new commit.

## AWS Resouces

- [AWS CodePipeline](https://aws.amazon.com/pt/codepipeline/)
- [AWS S3](https://aws.amazon.com/pt/s3/)
- [AWS ACM](https://aws.amazon.com/pt/certificate-manager/)
- [AWS CloudFront](https://aws.amazon.com/pt/cloudfront/)

## Static Website

- [web-cliente](https://github.com/laairoy/projeto-web-cliente)
