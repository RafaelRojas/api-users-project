
resource "aws_apigatewayv2_api" "crud_api" {
  name          = "crud_api"
  protocol_type = "HTTP"
}

# Define  HTTP crud api function routes 
#get users by querying user ID
resource "aws_apigatewayv2_route" "get_users_by_id" {
  api_id    = aws_apigatewayv2_api.crud_api.id
  route_key = "GET /users/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.get_users_by_id.id}"
}

#get all users
resource "aws_apigatewayv2_route" "get_users" {
  api_id    = aws_apigatewayv2_api.crud_api.id
  route_key = "GET /users"
  target    = "integrations/${aws_apigatewayv2_integration.get_users.id}"
}

#Put (modify) a user by its ID
resource "aws_apigatewayv2_route" "put_users" {
  api_id    = aws_apigatewayv2_api.crud_api.id
  route_key = "PUT /users"
  target    = "integrations/${aws_apigatewayv2_integration.put_users.id}"
}

#Delete a user by its ID
resource "aws_apigatewayv2_route" "delete_users_by_id" {
  api_id    = aws_apigatewayv2_api.crud_api.id
  route_key = "DELETE /users/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.delete_users_by_id.id}"
}

# Define HTTP crud api function integrations (connect api path with lambda)
resource "aws_apigatewayv2_integration" "get_users_by_id" {
  api_id             = aws_apigatewayv2_api.crud_api.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = data.terraform_remote_state.lambda.outputs.lambda_function_arn
  #Using suggested solution
  credentials_arn    = data.terraform_remote_state.iam.outputs.api_gateway_execution_role_arn
}

resource "aws_apigatewayv2_integration" "get_users" {
  api_id             = aws_apigatewayv2_api.crud_api.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = data.terraform_remote_state.lambda.outputs.lambda_function_arn
  #Using suggested solution
  credentials_arn    = data.terraform_remote_state.iam.outputs.api_gateway_execution_role_arn
}

resource "aws_apigatewayv2_integration" "put_users" {
  api_id             = aws_apigatewayv2_api.crud_api.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = data.terraform_remote_state.lambda.outputs.lambda_function_arn
  #Using suggested solution
  credentials_arn    = data.terraform_remote_state.iam.outputs.api_gateway_execution_role_arn
}

resource "aws_apigatewayv2_integration" "delete_users_by_id" {
  api_id             = aws_apigatewayv2_api.crud_api.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = data.terraform_remote_state.lambda.outputs.lambda_function_arn
  credentials_arn    = data.terraform_remote_state.iam.outputs.api_gateway_execution_role_arn
}


#The permissions block
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = data.terraform_remote_state.lambda.outputs.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.crud_api.execution_arn}/*/*"
}

####Stage with logs
resource "aws_cloudwatch_log_group" "api_crud_cwlg" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.crud_api.name}"

  retention_in_days = 30
}

resource "aws_apigatewayv2_stage" "dev" {
  api_id = aws_apigatewayv2_api.crud_api.id
  name        = "dev"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_crud_cwlg.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

#y que jalara, tu
output "api_gateway_url" {
  value = aws_apigatewayv2_api.crud_api.api_endpoint
}
