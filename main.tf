resource "aws_s3_bucket" "static_web" {
  bucket =   var.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "static_web_owner" {
  bucket = aws_s3_bucket.static_web.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "static_web_access" {
  bucket = aws_s3_bucket.static_web.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "static_web_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.static_web_owner,
   aws_s3_bucket_public_access_block.static_web_access,
  ]

  bucket = aws_s3_bucket.static_web.id
  acl    = "private"
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.static_web.id
  key = "index.html"
  source = "index.html"
  acl = "public-read"
  content_type  = "text/html"
}

resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.static_web.id
  key = "error.html"
  source = "error.html"
  acl = "public-read"
  content_type  = "text/html"
}


resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.static_web.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
depends_on = [ aws_s3_bucket_acl.static_web_acl ]
}