output "lambda_function_arn" {
  value = aws_lambda_function.crud_lambda.invoke_arn
}

output "lambda_function_name" {
  value = aws_lambda_function.crud_lambda.function_name
}

output "lambda_function_loggroup_name" {
  value = aws_cloudwatch_log_group.api_crud_cwlg.name
}