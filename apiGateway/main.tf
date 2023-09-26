resource "aws_apigatewayv2_api" "users_api_gw" {
  name          = "users-http-api"
  protocol_type = "HTTP"
}

##create user block begin
resource "aws_apigatewayv2_integration" "create_user_integration" {
  api_id                 = aws_apigatewayv2_api.users_api_gw.id
  integration_type       = "AWS_PROXY"
  connection_type        = "INTERNET"
  integration_method     = "POST"
  integration_uri        =  data.terraform_remote_state.createUserlambda.outputs.createuser_function_arn
  passthrough_behavior   = "WHEN_NO_MATCH"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "create_user_route" {
  api_id    = aws_apigatewayv2_api.users_api_gw.id
  route_key = "POST /users"
  target    = "integrations/${aws_apigatewayv2_integration.create_user_integration.id}"
}

resource "aws_lambda_permission" "apigw_create" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = data.terraform_remote_state.createUserlambda.outputs.createuser_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.users_api_gw.execution_arn}/*/POST/users"
}
##Create users block end

#delete user block begins
resource "aws_apigatewayv2_integration" "delete_user_integration" {
  api_id                 = aws_apigatewayv2_api.users_api_gw.id
  integration_type       = "AWS_PROXY"
  connection_type        = "INTERNET"
  integration_method     = "POST"
  integration_uri        =  data.terraform_remote_state.deleteUserlambda.outputs.deleteuser_function_arn
  passthrough_behavior   = "WHEN_NO_MATCH"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "delete_user_route" {
  api_id    = aws_apigatewayv2_api.users_api_gw.id
  route_key = "DELETE /users/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.delete_user_integration.id}"
}

resource "aws_lambda_permission" "apigw_delete" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = data.terraform_remote_state.deleteUserlambda.outputs.deleteuser_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.users_api_gw.execution_arn}/*/DELETE/users/{id}"
}
#delete user block ends

##list users block start
resource "aws_apigatewayv2_integration" "list_users_integration" {
  api_id                 = aws_apigatewayv2_api.users_api_gw.id
  integration_type       = "AWS_PROXY"
  connection_type        = "INTERNET"
  integration_method     = "POST"
  integration_uri        = data.terraform_remote_state.listUserslambda.outputs.listusers_function_arn
  passthrough_behavior   = "WHEN_NO_MATCH"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "list_users_route" {
  api_id    = aws_apigatewayv2_api.users_api_gw.id
  route_key = "GET /users"
  target    = "integrations/${aws_apigatewayv2_integration.list_users_integration.id}"
}

resource "aws_lambda_permission" "apigw_list_users" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = data.terraform_remote_state.listUserslambda.outputs.listusers_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.users_api_gw.execution_arn}/*/GET/users"
}
## list users block ends

##modify user block starts
resource "aws_apigatewayv2_integration" "modify_user_integration" {
  api_id                 = aws_apigatewayv2_api.users_api_gw.id
  integration_type       = "AWS_PROXY"
  connection_type        = "INTERNET"
  integration_method     = "POST"
  integration_uri        = data.terraform_remote_state.modifyUserlambda.outputs.modify_user_function_arn
  passthrough_behavior   = "WHEN_NO_MATCH"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "modify_users_route" {
  api_id    = aws_apigatewayv2_api.users_api_gw.id
  route_key = "PUT /users/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.modify_user_integration.id}"
}

resource "aws_lambda_permission" "apigw_modify_users" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = data.terraform_remote_state.modifyUserlambda.outputs.modify_user_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.users_api_gw.execution_arn}/*/PUT/users/{id}"
}
##modify user block ends

####Stage with logs
resource "aws_cloudwatch_log_group" "api_users_cwg" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.users_api_gw.name}"

  retention_in_days = 30
}

resource "aws_apigatewayv2_stage" "dev" {
  api_id = aws_apigatewayv2_api.users_api_gw.id
  name        = "dev"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_users_cwg.arn

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

output "api_gateway_url" {
  value = aws_apigatewayv2_api.users_api_gw.api_endpoint
}