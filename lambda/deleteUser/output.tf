output "deleteuser_function_arn" {
  value = aws_lambda_function.deleteUserHandler.invoke_arn
}

output "deleteuser_function_name" {
   value = aws_lambda_function.deleteUserHandler.function_name
}