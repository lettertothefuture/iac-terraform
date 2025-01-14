# BUCKET REACT WEB-PAGE
resource "aws_s3_bucket" "react_site" {
  bucket = var.react_site_bucket_name
  website {
    index_document = "index.html"
    # error_document = "error.html" # Optional
  }
}

# BUCKET LETTERS
resource "aws_s3_bucket" "letter_bucket" {
  bucket = var.letter_bucket_name
}

output "react_site_bucket" {
  value = aws_s3_bucket.react_site.bucket
}

output "letter_bucket" {
  value = aws_s3_bucket.letter_bucket.bucket
}
