variable "subnet_id" {
  description = "The subnet ID for ECS service"
  type        = string
  default     = "lettertothefuture"
}

variable "react_site_bucket_name" {
  description = "The S3 bucket name for the React site"
  type        = string
  default     = "react-site-bucket"
}

variable "letter_bucket_name" {
  description = "The S3 bucket name for letter"
  type        = string
  default     = "letter-json-bucket"
}
