

provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "jg-cloud-resume-bucket"
  tags = {
    Name        = "jg-cloud-resume-bucket"
    Environment = "Dev"
  }
}
 resource "aws_s3_bucket_website_configuration" "website_config" {
    bucket = aws_s3_bucket.my_bucket.id
    index_document {
      suffix = "index.html"
    }
  }

# resource "aws_s3_bucket_policy" "allow_public" {
#   bucket = aws_s3_bucket.my_bucket.id
#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": "*",
#       "Action": [
#         "s3:GetObject"
#       ],
#       "Resource": [
#         "arn:aws:s3:::jg-cloud-resume-bucket/*"
#       ]
#     }
#   ]
# }
# EOF
# }

resource "aws_s3_object" "site_items" {
  for_each = fileset("${path.module}/site", "**/*.*")

  bucket       = aws_s3_bucket.my_bucket.id
  key          = each.key
  source       = "${path.module}/site/${each.key}"
  content_type = lookup(tomap(local.mime_types), element(split(".", each.key), length(split(".", each.key)) - 1), null)
  etag         = filemd5("${path.module}/site/${each.key}")
}

locals {
  mime_types = {
    "css"  = "text/css"
    "html" = "text/html"
    "ico"  = "image/vnd.microsoft.icon"
    "js"   = "application/javascript"
    "json" = "application/json"
    "map"  = "application/json"
    "png"  = "image/png"
    "svg"  = "image/svg+xml"
    "txt"  = "text/plain"
  }
}
