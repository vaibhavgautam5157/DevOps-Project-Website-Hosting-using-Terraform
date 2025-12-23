resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucketname
}

resource "aws_s3_bucket_ownership_controls" "mybucket" {
  bucket = aws_s3_bucket.mybucket.bucket

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "mybucket" {
  bucket = aws_s3_bucket.mybucket.bucket

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "mybucket" {
  depends_on = [
    aws_s3_bucket_ownership_controls.mybucket,
    aws_s3_bucket_public_access_block.mybucket,
  ]

  bucket = aws_s3_bucket.mybucket.bucket
  acl    = "public-read"
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.mybucket.bucket
  key    = "index.html"
  source = "index.html"
  acl    = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.mybucket.bucket
  key    = "error.html"
  source = "error.html"
  acl    = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "profile" {
  bucket = aws_s3_bucket.mybucket.bucket
  key    = "inner-logo.png" 
  source = "inner-logo.png"
  acl    = "public-read"
  content_type = "image/png"
}

resource "aws_s3_object" "wallpaper" {
  bucket = aws_s3_bucket.mybucket.bucket
  key    = "wallpaperflare.com_wallpaper (13).jpg"
  source = "wallpaperflare.com_wallpaper (13).jpg"
  acl    = "public-read"
  content_type = "image/jpg"
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.mybucket.bucket
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }

  depends_on = [ aws_s3_bucket_acl.mybucket ]
}