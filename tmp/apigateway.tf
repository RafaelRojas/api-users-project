resource "aws_apigatewayv2_api" "crud_api" {
  name          = "crudAPI"
  protocol_type = "HTTP"
  description   = "Example HTTP API"
}

# Define  HTTP crud api function routes 
resource "aws_apigatewayv2_route" "get_users_by_id" {
  api_id    = aws_apigatewayv2_api.crud_api.id
  route_key = "GET /users/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.get_users_by_id.id}"
}

resource "aws_apigatewayv2_route" "get_users" {
  api_id    = aws_apigatewayv2_api.crud_api.id
  route_key = "GET /users"
  target    = "integrations/${aws_apigatewayv2_integration.get_users.id}"
}

resource "aws_apigatewayv2_route" "put_users" {
  api_id    = aws_apigatewayv2_api.crud_api.id
  route_key = "PUT /users"
  target    = "integrations/${aws_apigatewayv2_integration.put_users.id}"
}

resource "aws_apigatewayv2_route" "delete_users_by_id" {
  api_id    = aws_apigatewayv2_api.crud_api.id
  route_key = "DELETE /users/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.delete_users_by_id.id}"
}


# Define HTTP crud api function integrations
resource "aws_apigatewayv2_integration" "get_users_by_id" {
  api_id             = aws_apigatewayv2_api.crud_api.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.crud_lambda.invoke_arn
  credentials_arn    = aws_iam_role.api_gateway_execution_role.arn
}

resource "aws_apigatewayv2_integration" "get_users" {
  api_id             = aws_apigatewayv2_api.crud_api.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.crud_lambda.invoke_arn
  credentials_arn    = aws_iam_role.lambda_role.arn
}

resource "aws_apigatewayv2_integration" "put_users" {
  api_id             = aws_apigatewayv2_api.crud_api.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.crud_lambda.invoke_arn
  credentials_arn    = aws_iam_role.api_gateway_execution_role.arn
}

resource "aws_apigatewayv2_integration" "delete_users_by_id" {
  api_id             = aws_apigatewayv2_api.crud_api.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.crud_lambda.invoke_arn
  credentials_arn    = aws_iam_role.api_gateway_execution_role.arn
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "3322574265"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.crud_lambda.arn
  principal     = "apigateway.amazonaws.com"
  #source_arn    = "arn:aws:execute-api:us-east-1:831033405962:o5fn9tu5h2/*/users/*"
  source_arn  = "${aws_apigatewayv2_api.crud_api.execution_arn}/*/*/*"
}

# Define "dev" stage
resource "aws_apigatewayv2_stage" "dev" {
  api_id      = aws_apigatewayv2_api.crud_api.id
  name        = "dev"
  description = "Development Stage"
  auto_deploy  = "true"
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.crudapi_logs.arn
    format = "{\"requestId\":\"$context.requestId\",\"ip\":\"$context.identity.sourceIp\",\"requestTime\":\"$context.requestTime\",\"httpMethod\":\"$context.httpMethod\",\"routeKey\":\"$context.routeKey\",\"status\":\"$context.status\",\"protocol\":\"$context.protocol\",\"responseLength\":\"$context.responseLength\"}"
  }
}

# Create an initial deployment for the "dev" stage
resource "aws_apigatewayv2_deployment" "dev_initial" {
  api_id = aws_apigatewayv2_api.crud_api.id
  description = "Initial Deployment for Dev Stage"
  depends_on = [
    aws_apigatewayv2_integration.get_users_by_id,
    aws_apigatewayv2_integration.get_users,
    aws_apigatewayv2_integration.put_users,
    aws_apigatewayv2_integration.delete_users_by_id,
  ]
}


data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_lambda_permission" "api_gateway_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "arn:aws:lambda:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:function:CRUDLambda"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:${aws_apigatewayv2_api.crud_api.id}/*/*/users"
  #source_arn = "${aws_apigatewayv2_api.crud_api.execution_arn}/*/*/*"
}

# Outputs the API Gateway URL
output "api_gateway_url" {
  value = aws_apigatewayv2_api.crud_api.api_endpoint
}