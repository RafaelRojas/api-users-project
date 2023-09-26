output "listusers_function_arn" {
  value = aws_lambda_function.ListUsersHandler.invoke_arn
}

output "listusers_function_name" {
   value = aws_lambda_function.ListUsersHandler.function_name
}