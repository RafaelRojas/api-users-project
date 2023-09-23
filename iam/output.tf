output "lambda_role" {
  value = aws_iam_role.lambda_role.arn
}

output "lambda_role_name" {
  value = aws_iam_role.lambda_role.name
}

output "api_gateway_execution_role_arn" {
  value = aws_iam_role.api_gateway_execution_role.arn
}




#suggested solution for apigw
# output "execution_role_apigateway" {
#   value = aws_iam_role.lambda_execution_role_4_apigw.arn
# }