#Cloudwatch group for lambda
resource "aws_cloudwatch_log_group" "handler_lambda" {
  name = "/aws/lambda/${aws_lambda_function.crud_lambda.function_name}"
  retention_in_days = 1
}

# CloudWatch Logs group for access logging
resource "aws_cloudwatch_log_group" "crudapi_logs" {
  name = "/aws/apiGateway/${aws_apigatewayv2_api.crud_api.name}"
  retention_in_days = 1
}