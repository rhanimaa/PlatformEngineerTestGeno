provider "aws" {
  region = "us-east-1"
}

# S3 Buckets
resource "aws_s3_bucket" "rahma_bucket_1" {
  bucket = "rahma-bucket-1-2021"
}

resource "aws_s3_bucket" "rahma_bucket_2" {
  bucket = "rahma-bucket-2-2021"
}

# Lambda Function
resource "aws_lambda_function" "rahma_lambda_1" {
  function_name = "rahma_lambda_1"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  role          = aws_iam_role.rahma_role_1.arn

  filename         = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")

  environment {
    variables = {
      DESTINATION_BUCKET = aws_s3_bucket.rahma_bucket_2.bucket
    }
  }
}

# IAM Role for Lambda
resource "aws_iam_role" "rahma_role_1" {
  name = "rahma_role_1"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "rahma_policy_1" {
  role = aws_iam_role.rahma_role_1.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Effect   = "Allow"
        Resource = [
          "${aws_s3_bucket.rahma_bucket_1.arn}/*",
          "${aws_s3_bucket.rahma_bucket_2.arn}/*"
        ]
      }
    ]
  })
}

# S3 Event Notification
resource "aws_s3_bucket_notification" "rahma_notification_1" {
  bucket = aws_s3_bucket.rahma_bucket_1.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.rahma_lambda_1.arn
    events             = ["s3:ObjectCreated:*"]
    filter_suffix      = ".jpg"
  }
}

# IAM Users
resource "aws_iam_user" "rahma_user_1" {
  name = "rahma_user_1"
}

resource "aws_iam_user" "rahma_user_2" {
  name = "rahma_user_2"
}

resource "aws_iam_user_policy" "rahma_user_policy_1" {
  user = aws_iam_user.rahma_user_1.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.rahma_bucket_1.arn}/*"
      }
    ]
  })
}

resource "aws_iam_user_policy" "rahma_user_policy_2" {
  user = aws_iam_user.rahma_user_2.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject"
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.rahma_bucket_2.arn}/*"
      }
    ]
  })
}
