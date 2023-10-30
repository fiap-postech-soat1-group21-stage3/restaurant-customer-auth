terraform {
  cloud {
    organization = "fiap-postech-soat1-group21"
    workspaces {
      name = "restaurant"
    }
  }
}

#defining the provider as aws
provider "aws" {
  region     = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
}

resource "aws_iam_role" "lambda_role" {
  name               = "restaurant_auth"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_policy" "iam_policy_for_lambda" {
  name        = "aws_iam_policy_for_terraform_aws_lambda_role"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy      = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
     "Resource": "arn:aws:logs:*:*:*",
     "Effect": "Allow"
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}

// zip the binary, as we can use only zip files to AWS lambda
data "archive_file" "function_archive" {
  type        = "zip"
  source_file = "${path.module}/tfgenerated/authorizer"
  output_path = "${path.module}/tfgenerated/auth.zip"
}


resource "aws_lambda_function" "terraform_lambda_func" {
  filename         = "${path.module}/tfgenerated/auth.zip"
  function_name    = "restaurant_auth"
  role             = aws_iam_role.lambda_role.arn
  handler          = "authorizer"
  runtime          = "go1.x"
  source_code_hash = data.archive_file.function_archive.output_base64sha256
  depends_on       = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
}