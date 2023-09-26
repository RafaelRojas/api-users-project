resource "aws_api_gateway_rest_api" "users_apigw" {
  name        = "users_apigw"
  description = "Product API Gateway"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}
resource "aws_api_gateway_resource" "users" {
  rest_api_id = aws_api_gateway_rest_api.users_apigw.id
  parent_id   = aws_api_gateway_rest_api.users_apigw.root_resource_id
  path_part   = "users"
}
resource "aws_api_gateway_method" "createuser" {
  rest_api_id   = aws_api_gateway_rest_api.users_apigw.id
  resource_id   = aws_api_gateway_resource.users.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "deleteuser" {
  rest_api_id   = aws_api_gateway_rest_api.users_apigw.id
  resource_id   = aws_api_gateway_resource.users.id
  http_method   = "DELETE"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "createuser-lambda" {
rest_api_id = aws_api_gateway_rest_api.users_apigw.id
  resource_id = aws_api_gateway_method.createuser.resource_id
  http_method = aws_api_gateway_method.createuser.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri = data.terraform_remote_state.createUserlambda.outputs.createuser_function_arn
}

resource "aws_api_gateway_integration" "deleteuser-lambda" {
rest_api_id = aws_api_gateway_rest_api.users_apigw.id
  resource_id = aws_api_gateway_method.createuser.resource_id
  http_method = aws_api_gateway_method.deleteuser.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri = data.terraform_remote_state.deleteUserlambda.outputs.deleteuser_function_arn
}

resource "aws_lambda_permission" "apigw-CreateUserHandler" {
  action        = "lambda:InvokeFunction"
  function_name = data.terraform_remote_state.createUserlambda.outputs.createuser_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.users_apigw.execution_arn}/*/users"
}

resource "aws_lambda_permission" "apigw-DeleteUserHandler" {
  action        = "lambda:InvokeFunction"
  function_name = data.terraform_remote_state.deleteUserlambda.outputs.deleteuser_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.users_apigw.execution_arn}/*/users"
}


resource "aws_api_gateway_deployment" "usersapidev" {
  depends_on = [
    aws_api_gateway_integration.createuser-lambda
  ]
  rest_api_id = aws_api_gateway_rest_api.users_apigw.id
  stage_name  = "dev"
}