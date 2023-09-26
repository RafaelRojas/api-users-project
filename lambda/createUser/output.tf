output "createuser_function_arn" {
  value = aws_lambda_function.CreateUserHandler.invoke_arn
}

output "createuser_function_name" {
   value = aws_lambda_function.CreateUserHandler.function_name
}