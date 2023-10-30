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

resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "restaurant-gateway"
  protocol_type = "HTTP"
}

# data "aws_lambda_function" "authorizer" {
#   function_name = "login"
# }

resource "aws_apigatewayv2_authorizer" "gateway_authorizer" {
  api_id           = aws_apigatewayv2_api.api_gateway.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "gateway-authorizer"
}

# resource "aws_lambda_permission" "lambda_permission" {
#   statement_id  = "AllowExecutionFromAPIGW"
#   action        = "lambda:InvokeFunction"
#   function_name = data.aws_lambda_function.authorizer.function_name
#   principal     = "apigateway.amazonaws.com"
# }