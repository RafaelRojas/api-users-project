output "modify_user_function_arn" {
  value = aws_lambda_function.modifyUserHandler.invoke_arn
}

output "modify_user_function_name" {
   value = aws_lambda_function.modifyUserHandler.function_name
}