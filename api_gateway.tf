resource "aws_api_gateway_rest_api" "terraform_lambda_func" {
  name        = "RestarauntAPI"
  description = "Restaurant authorization"
}

resource "aws_api_gateway_resource" "apig_resource" {
  parent_id   = aws_api_gateway_rest_api.terraform_lambda_func.root_resource_id
  path_part   = "auth"
  rest_api_id = aws_api_gateway_rest_api.terraform_lambda_func.id
}

resource "aws_api_gateway_resource" "apig_customer" {
  parent_id   = aws_api_gateway_resource.apig_resource.id
  path_part   = "customer"
  rest_api_id = aws_api_gateway_rest_api.terraform_lambda_func.id
}

resource "aws_api_gateway_method" "customer_method" {
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.apig_customer.id
  rest_api_id   = aws_api_gateway_rest_api.terraform_lambda_func.id
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.terraform_lambda_func.id
  resource_id             = aws_api_gateway_resource.apig_customer.id
  http_method             = aws_api_gateway_method.customer_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.terraform_lambda_func.invoke_arn
}

resource "aws_api_gateway_deployment" "apig_deploy" {
  depends_on  = [aws_api_gateway_integration.lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.terraform_lambda_func.id
}

resource "aws_api_gateway_stage" "apig_stage" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.terraform_lambda_func.id
  deployment_id = aws_api_gateway_deployment.apig_deploy.id
}

output "api_gateway_url" {
  value = aws_api_gateway_deployment.apig_deploy.invoke_url
}